import logging
import os

import boto3
from boto3.dynamodb.conditions import Key
from src import config
logger = logging.getLogger('lambda_function')
logger.setLevel(os.environ['LogLevel'])


def get_product_details(product_id):
    """
    Gets the product details or None if no match is found
    :param product_id: product id
    :return: dict
    """
    config_settings = config.get_config()
    db_client = boto3.resource('dynamodb', region_name = config_settings['region'])
    table = db_client.Table(config_settings['TableName'])

    response = table.query(KeyConditionExpression=Key('ProductId').eq(product_id))

    products = response.get('Items', None)

    return products
