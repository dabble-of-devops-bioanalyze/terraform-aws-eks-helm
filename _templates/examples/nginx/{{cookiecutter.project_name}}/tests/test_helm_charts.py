#!/usr/bin/env python

"""Tests for `terraform-aws-eks-helm nginx` example."""

import pytest

from pprint import pprint
import time
import logging
import json
import requests

logging.basicConfig(level=logging.INFO)


def test_https_nginx1():
    """Test running a curl request against nginx1"""
    logging.info('Running tests against nginx1')
    r = requests.get('https://nginx1.bioanalyzedev.io')

    assert r.status_code == 200, pprint(r)


def test_https_nginx2():
    """Test running a curl request against nginx2"""
    logging.info('Running tests against nginx2')
    r = requests.get('https://nginx2.bioanalyzedev.io')

    assert r.status_code == 200, pprint(r)