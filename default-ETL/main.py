import argparse
import json
import os
from ssl import create_default_context

import elasticsearch

from pypel import ProcessFactory
from pypel import clean_index
from pypel import init_index
from pypel.utils.logs import initialize_logs

logger = initialize_logs(__name__)


def main():
    with open("./conf/config.json") as f:
        config = json.load(f)

    es = elasticsearch.Elasticsearch([
        {
            'host': config.get("host", "localhost"),
            'http_auth': (config.get("user"), config.get("pwd")),
            'use_ssl': config.get("scheme", "http") == "https",
            'scheme': config.get("scheme", 'http'),
            'port': config.get("port", 9200),
        }
    ], verify_certs=False,
    )

    es_index_client = elasticsearch.client.IndicesClient(es)

    with open("./conf/index_mappings.json") as f:
        mappings = json.load(f)
    with open("./conf/config.json") as f:
        path_to_data = json.load(f)["path_to_data"]
    with open("./conf/parameters.json") as f:
        params = json.load(f)

    args = get_args()
    process_range = args.process_type
    index_pattern = get_index_pattern(params, process_range)

    clean = args.clean_indices
    if clean is True:
        clean_index(mappings, es_index_client, index_pattern)
        init_index(mappings, es_index_client, index_pattern)
    process_files(es, params, path_to_data, process_range)


def get_args():
    parser = argparse.ArgumentParser(description='Process the type of Process')
    parser.add_argument("-p", "--process-type", default="all", type=str, help="get the type of Process")
    parser.add_argument("-c", "--clean-indices", dest="clean_indices", action='store_true', help="specify if indices should be deleted")
    args = parser.parse_args()
    return args


def get_index_pattern(params, process):
    if process == "all":
        index_pattern = "all"
    elif process in params["process"].keys():
        index_pattern = params["process"][process]["index_pattern"]
    else:
        raise Exception(f"The given process argument {process} does not exist in config.json.")
    return index_pattern


def process_files(es, params, path_to_data, process_range: str = "all"):
    process_names = params["process"]

    process_factory = ProcessFactory(path_to_data)

    if process_range == "all":
        for process_name in process_names.keys():
            process_folder(es,
                           params,
                           process_factory,
                           process_name,
                           path_to_data=path_to_data)
    else:
        if process_range in process_names.keys():
            process_name = process_range
            process_folder(es,
                           params,
                           process_factory,
                           process_name,
                           path_to_data=path_to_data)
        else:
            logger.warning(f"Process {process_range} not found")


def process_folder(es, params, process_factory, process_name, path_to_data):
    elastic_index = params["process"][process_name]["index_pattern"]
    process = process_factory.create_process(params["process"][process_name], elastic_index)

    path_to_class_data = get_path_to_class_data(params, process_name, path_to_data=path_to_data)

    files = [os.path.join(path_to_class_data, file)
             for file in os.listdir(path_to_class_data)
             if not os.path.isdir(os.path.join(path_to_class_data, file))]
    for file in files:
        logger.debug(f"Extracting {file}")
        df = process.extract(file,
                             dtype=str,
                             keep_default_na=False)
        logger.debug(f"Transforming df extracted from {file}")
        df = process.transform(df, df_replace={"": None})
        logger.debug(f"Loading processed {file}")
        process.load(es_indice=elastic_index,
                     df=df,
                     es_instance=es,
                     dont_append_date=True)


def get_path_to_class_data(params, process_name, path_to_data):
    return os.path.join(path_to_data, params["process"][process_name]["path"])


if __name__ == "__main__":
    main()
