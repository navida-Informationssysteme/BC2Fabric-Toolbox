# Finance Reporting Accelerator

## Introduction

Power BI Accelerator for Power BI reporting based on BC2Fabric mirroring data. This tool installs the necessary SQL views and automatically deploys the Finance Power BI report into your workspace.

## Installation

Follow the Semantic Link Labs powered workflow: import the ready-made notebook directly into your Fabric workspace, configure your environment details, and let it provision both the SQL views and the Power BI App.

### Quick Start

1.  **Create a PySpark notebook** in your Fabric workspace and run the following bootstrap cell:

    ```python
    %pip install -q --disable-pip-version-check semantic-link-labs
    import sempy_labs as labs

    labs.import_notebook_from_web(
        overwrite=True, 
        notebook_name="Finance_Accelerator_Installer",
        url="https://raw.githubusercontent.com/navida-Informationssysteme/BC2Fabric-Toolbox/main/Accelerators/Finance-Reporting/finance_views_installer.ipynb"
    )
    ```

2.  **Open the imported `Finance_Accelerator_Installer` notebook.**

3.  **Update the Global Configuration** at the very top of the notebook. You must define the following three parameters:

      * **`SQL_ENDPOINT`**: The SQL Analytics Endpoint string of your Fabric Lakehouse or Warehouse (e.g., `xy123...datawarehouse.fabric.microsoft.com`).
      * **`DATABASE_NAME`**: The name of the Lakehouse or Warehouse where the data resides (should be `bc2fabric_mirror`).
      * **`COMPANY_NAME`**: The specific company name you want the Power BI report to filter by default (e.g., `CRONUS DE`).

4.  **Run the notebook top to bottom.** The script will perform the following actions:

      * **SQL Setup:** Connect to your endpoint and create/update the necessary Finance SQL Views.
      * **Report Deployment:** Download the `BC2Fabric_Finance_App.pbix` from GitHub and import it into your workspace.
      * **Configuration:** Automatically bind the report to your SQL Endpoint and update the "Company" parameter.
      * **Refresh:** Trigger an initial dataset refresh.

Once the notebook finishes successfully, the **BC2Fabric\_Finance\_App** report will be ready for use in your workspace.