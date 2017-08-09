> This is a minimal fork that gets you to running a simple R Hello World application on Azure Functions. For a more extensive example, please check out the upstream repository.

# Running R scripts on Azure Functions

In this tutorial we will show how to deploy a R script on Azure Function.

## Azure Functions

[Azure Functions](https://azure.microsoft.com/en-us/services/functions/) supports a variety of languages (C#, js, batch, PowerShell, Python). However R is not natively supported, in the following tutorial we will show how to run R scripts on Azure Function.

Azure Function can be used in several scenarios because of the broad choice of triggers it offers:
- Timer trigger, executes a Function on a schedule.
- Http trigger, execute a Function after an HTTP call.
- Azure Queue Storage, Service Bus, Blob Storage, triggers the function when a new object or message is received.

## Creating an Azure Function

1. Make sure you have an Azure Subscription and that you are logged in the [Azure Portal](https://ms.portal.azure.com)

2. Navigate to the [Function creation wizard](https://ms.portal.azure.com/#create/Microsoft.FunctionApp).

3. Pick a name, a resource group, a region and a storage account for your function. The difference between the consumption plan and the hosted plan is price and performance. The consumption plan is much cheaper and in most use cases can be essentially free apart from the storage cost. However it has a 5 minutes execution time limit, and runs slower than the hosted plan. What you chose will depend on your budget and performance requirements. **If you want the twitter bot to tweet the temperature plot, use a hosted plan** ![](./media/0_function_creation.PNG)

## Installing the R extension

1. Once you have your Azure Function set up, navigate to the Kudu Console of the function. ![](./media/1_kudu_console.PNG)

2. Navigate to the site extension tab, search for **Rscript** and install the **R 3.3.3 x64** extension. It can take up to 5 minutes to install on the slower plans. ![](./media/2_install_extension.PNG) Once the installation in completed, you might get a `installation failed` pop-up message, ignore it. Refresh the page and navigate to the `installed` tab. You should see the R extension there.


3. Once the extension is installed, click on **Restart Site** ![](./media/3_restart.PNG)

4. When the site is back online you can test that R has been properly installed by running `Rscript --help` in the kudu powershell debug console.
![](./media/5_successful_deployment.PNG)

5. To make sure the installation is complete **run the following command** in the powershell kudu console and wait until completion (this can take up to ~10 min on consumption plan):

```ps
unzip -n D:\home\SiteExtensions\R-3.3.3x64\R-3.3.3.zip -d D:\home
```

Sometimes the installation times-out and fails to complete, especially on the consumption plan. This is being investigated. If you don't run the above command you might encounter a similar error as the following:

```
2017-08-02T07:46:06  Welcome, you are now connected to log-streaming service.
2017-08-02T07:46:10.787 Function started (Id=56a4dde7-e44b-4fa7-8820-686b381fb341)
2017-08-02T07:46:14.230 During startup - Warning messages:
2017-08-02T07:46:14.230 1: package 'utils' in options("defaultPackages") was not found
2017-08-02T07:46:14.230 2: package 'grDevices' in options("defaultPackages") was not found
2017-08-02T07:46:14.230 3: package 'graphics' in options("defaultPackages") was not found
2017-08-02T07:46:14.230 4: package 'stats' in options("defaultPackages") was not found
2017-08-02T07:46:14.277 Loading required package: httr
2017-08-02T07:46:14.293 Error: could not find function "install.packages"
2017-08-02T07:46:14.293 In addition:
2017-08-02T07:46:14.293 Warning message:
2017-08-02T07:46:14.293 In library(package, lib.loc = lib.loc, character.only = TRUE, logical.return = TRUE,  :
2017-08-02T07:46:14.293 
2017-08-02T07:46:14.293 there is no package called 'httr'
2017-08-02T07:46:14.308 Execution halted
2017-08-02T07:46:14.324 Function completed (Success, Id=56a4dde7-e44b-4fa7-8820-686b381fb341, Duration=3545ms)
```

## Running any R scripts on Azure Function

1. You only need to create an Azure Function and call Rscript.exe from powershell. All you need is a R script `script.r` for example, and have a `run.ps1` similar to this:

```
cd D:\home\site\wwwroot\YourFunctionName
D:\home\R-3.3.3\bin\x64\Rscript.exe script.r 2>&1
```


## Setting up the Hello World bot

1. This current repository contains the code for an Azure Function that prints a hello world message that can be seen in the logs. The first thing to do is to enable continuous deployment on the function. 

![](./media/41_deployment.PNG)

![](./media/4_deployment.PNG)

2. You can select external repository and set the address to this repository `https://github.com/vitoc/azure-function-r` and branch `master`

3. Click on `sync` and refresh the page. You should see the code in your Azure Function. 

4. The `TriggerTimerFunction` folder contains what is necessary to run a function. There is the `run.ps1` file that is executed when the function is triggered. The `function.json` file defines the triggers, bindings and output of the function. You can read more about them in the [Azure Function documentation](https://docs.microsoft.com/en-us/azure/azure-functions/). The `run.ps1` script contains:
    ```
    cd D:\home\site\wwwroot\script
    D:\home\R-3.3.3\bin\x64\Rscript.exe script.r 2>&1
    ```
    This powershell script change the directory to the `script` directory of this repository and execute the R script while redirecting the stderr to stdout.

## Setting up the Hello World bot

1. When you're done, click `Run` on the portal and you should see `Hello, World!` printed in the logs.

### Limitations

The more complex use cases would need some a bit more powershell scripting for example to return an JSON HTTP response, but it consists only of redirecting the stdout of the R process to the normal powershell commands.

### Acknowledgements

Thanks [Andrie De Vries](https://github.com/andrie) for the help in R and [Mathew Salvaris](https://github.com/msalvaris) for the svg hack.
