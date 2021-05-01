import os
import getpass
from time import sleep
from argparse import ArgumentParser

import requests
from stem import Signal
from stem.control import Controller

from config import logger
from search_controller import SearchController


def change_ip_address(password):
    """Change IP address over Tor connection

    :type password: str
    :param password: Tor authentication password
    """

    logger.info("Changing ip address...")
    with Controller.from_port(port=9051) as controller:
        controller.authenticate(password=password)
        controller.signal(Signal.NEWNYM)
        controller.close()


def get_arg_parser():
    """Get argument parser

    :rtype: ArgumentParser
    :returns: ArgumentParser object
    """

    arg_parser = ArgumentParser()
    arg_parser.add_argument("-q", "--query", help="Search query")

    return arg_parser


def main():

    arg_parser = get_arg_parser()
    args = arg_parser.parse_args()

    if not args.query:
        logger.error("Run with search query!")
        arg_parser.print_help()
        raise SystemExit()

    os.environ["WDM_LOG_LEVEL"] = "0"
    password = os.environ.get("TOR_PWD", None)

    if not password:
        password = getpass.getpass("Enter tor password: ")

    change_ip_address(password)

    response = requests.get("https://api.myip.com", proxies={"https": "127.0.0.1:8118"})
    logger.info(f"Connecting with IP: {response.json()['ip']}")

    search_controller = SearchController(args.query)
    ads = search_controller.search_for_ads()

    if not ads:
        logger.info("No ads in the search results!")
    else:
        logger.info(f"Found {len(ads)} ads")
        search_controller.click_ads(ads)
        search_controller.end_search()


if __name__ == "__main__":

    main()