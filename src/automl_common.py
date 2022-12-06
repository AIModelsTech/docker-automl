import os
from automl_logger import logger
from azureml.core import Dataset, Workspace


def get_environ(name, required=False):
    """Get environment variable.
    
    Args:
        name (str): name of environment variable
        required (bool): (optional) if True and evironment variable does not exist throw error
    
    Returns:
        str with environment variable contenets or None.
    """
    ret = os.environ.get(name, None)
    if required and ret is None:
        logger.error(f"Environment variable {name} is required but not set!")
        exit(1)
    return ret


class AutoML:
    """Handler class for Azure AutoML."""

    def __init__(self):
        self.ws = Workspace.get(
            name=get_environ("WORKSPACE_NAME", required=True),
            subscription_id=get_environ("SUBSCRIPTION_ID", required=True),
            resource_group=get_environ("RESOURCE_GROUP", required=True),
        )
        self.ws.write_config(file_name=".ws_config.json")

    def get_dataset(self, name, as_dataframe=False):
        """Get data set from Azure.
        
        Args:
            name (str): name of dataset.
        
        Returns:
            azureml.core.Dataset if as_dataframe is False else pandas.dataframe.
        """
        logger.debug(f"Getting dataset {name} from Azure...")
        dataset = Dataset.get_by_name(self.ws, name=name)
        if as_dataframe:
            logger.debug("Converting data to dataframe...")
            dataset = dataset.to_pandas_dataframe()
        return dataset

