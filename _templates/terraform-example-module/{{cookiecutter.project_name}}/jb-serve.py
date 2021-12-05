import subprocess
from pathlib import Path
import os
import glob
import json

import click
from livereload import Server

# This tool comes from - https://gist.github.com/tnwei/726d377410b9a6285ddc1b18c4e67dc6
# with thanks!

@click.command()
@click.argument("pathsource", default=".", type=Path)
@click.option("-o", "--outputdir", default="_build/html", type=Path, show_default=True)
@click.option("-e", "--examplesdir", default="examples", type=Path, show_default=True)
@click.option("-p", "--port", default=8002, type=click.INT, show_default=True)
def main(pathsource: Path, examplesdir: Path, outputdir: Path, port: int):
    """
    Script to serve a jupyter-book site, which rebuilds when files have
    changed and live-reloads the site. Basically `mkdocs serve`
    but for jupyter-book. Use by calling `python jb-serve.py [OPTIONS] [PATH_SOURCE]`.

    \b
    Args
    ----
    PATHSOURCE: Directory in `jb build <dir>`
    outputdir: Directory where HTML output is generated. `jb` defaults to `_build/html`
    examplesdir: Directory where terraform examples are located. defaults to `examples`.
    port: Port to host the webserver. Default is 8002

    \b
    Refs
    ----
    + https://github.com/executablebooks/sphinx-autobuild/issues/99#issuecomment-722319104
    + mkdocs docs on github
    """
    def gencookiecutter_dirs():
        os.makedirs('_templates/module', mode = 0o777, exist_ok = False)
        os.makedirs('_templates/examples', mode = 0o777, exist_ok = False)
        examples = glob.glob('examples/*')
        example_dirs = []
        for example in examples:
            if os.path.isdir(example) and example not in example_dirs:
                example_dirs.append(example)

        for example in example_dirs:
            os.makedirs(f'_templates/{example}', mode = 0o777, exist_ok = False)
        return example_dirs

    def gencookiecutters():
        example_dirs = gencookiecutter_dirs()

    def pygmentize():
        terraform_files = glob.glob(f'{examplesdir}/**/**.tf', recursive=True)
        for terraform_file in terraform_files:
            dirname = os.path.dirname(terraform_file)
            tf_html_dir = os.path.join(dirname, '_html')
            basename = os.path.basename(terraform_file)
            tf_html_file =  os.path.join(tf_html_dir, f"{basename}.html")
            if not os.path.exists(tf_html_dir):
                subprocess.run(["mkdir", "-p", tf_html_dir])
            subprocess.run(["bash", "-c", f"pygmentize -l terraform -f html {terraform_file} > {tf_html_file}"])

    def build():
        subprocess.run(["jb", "clean", pathsource])
        subprocess.run(["jb", "build", pathsource])

    # Build if not exists upon startup
    if not os.path.exists(outputdir):
        build()

    server = Server()

    DELAY=10
    # Globbing for all supported file types under examplesdir
    server.watch(os.path.join(examplesdir, "**/**.tf"), pygmentize, delay=DELAY)
    server.watch(os.path.join(examplesdir, "**/*.tf"), pygmentize, delay=DELAY)

    # Globbing for all supported file types under jupyter-book
    # Ignore unrelated files
    server.watch(os.path.join(examplesdir, "**/*.md"), build)
    server.watch(os.path.join(pathsource, "**/*.md"), build)
    server.watch(os.path.join(pathsource, "**/*.ipynb"), build)
    server.watch(os.path.join(pathsource, "**/**.rst"), build)
    server.watch(pathsource / "_config.yml", build)
    server.watch(pathsource / "_toc.yml", build)

    server.serve(root=outputdir, port=port, host='0.0.0.0')

if __name__ == "__main__":
    main()
