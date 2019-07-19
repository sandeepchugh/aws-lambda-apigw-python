import json
import logging
import os

from src import product_handler, request

logger = logging.getLogger('lambda_function')
logger.setLevel(os.environ['LogLevel'])


def format_response(status_code, body):
    """
    formats the lambda response to api gateway response format
    :param status_code: response status code
    :param body: response body
    :return: dict
    """
    return {
        "statusCode": status_code,
        "body": json.dumps(body)
    }


def function_handler(event, context):
    """
    Lambda function handler
    :param event: aws api gateway event
    :param context: lambda context
    :return: formatted response for api gateway output
    """
    logger.info('Entering lambda_function.function_handler')

    request_params = request.parse_request(event)

    logger.debug("Request - product_id: {}".format(request_params['product_id']))

    product = product_handler.get_product_details(request_params['product_id'])

    if product is None:
        return format_response(404, "")

    if logger.level == logging.DEBUG:
        logger.debug("Response : {}".format(json.dumps(product)))

    return format_response(200, product)
