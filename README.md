
---

# 🌐 OpenCTI Deployment on Azure Using Terraform

**Efficient and Scalable Cyber Threat Intelligence Infrastructure with Azure and Terraform**  
This guide will help you deploy, manage, and scale OpenCTI on Azure using Terraform, with a focus on modularity, automation, and ease of management.

---

## 📑 Table of Contents

1. [Overview](#overview)
2. [Pre-Requisites](#pre-requisites)
3. [Folder Structure](#folder-structure)
4. [Deployment Instructions](#deployment-instructions)
   - [Set Up Azure Provider](#set-up-azure-provider)
   - [Configure Environment Variables](#configure-environment-variables)
   - [Deploy OpenCTI](#deploy-opencti)
   - [Deploy Specific Module From Root](#deploy-specific-module-from-root)
5. [Comprehensive Terraform Commands](#comprehensive-terraform-commands)
6. [Managing the Infrastructure](#managing-the-infrastructure)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)
9. [References](#references)

---

## 📋 1. Overview <a name="overview"></a>

This documentation guides you through deploying **OpenCTI** (Open Cyber Threat Intelligence) on **Azure** using **Terraform**. The deployment is organized into distinct environments (e.g., `dev`, `test`, `mgmt`), with reusable Terraform modules to maintain consistency and scalability.

OpenCTI provides powerful tools for managing cyber threat intelligence data, and Terraform enables the automation of infrastructure deployment and scaling across cloud environments like Azure.

---

## ✅ 2. Pre-Requisites <a name="pre-requisites"></a>

Make sure you have the following before beginning:

- **Terraform** installed on your local machine  
  *[Install Terraform](https://www.terraform.io/downloads)*
  
- **Azure CLI** installed  
  *[Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)*

- An **Azure Subscription** with appropriate permissions (e.g., Contributor)

---

## 🗂️ 3. Folder Structure <a name="folder-structure"></a>

The project is structured to handle different environments and modules efficiently. The folders are organized as follows:

```
env/
  ├── dev/
  │   └── terraform.tfvars
  ├── test/
  │   ├── backend-config.tfvars
  │   └── terraform.tfvars
  ├── mgmt/
  │   ├── backend-config.tfvars
  │   └── terraform.tfvars

modules/
  ├── opencti-appgw-dev/
  ├── opencti-appgw-mgmt/
  ├── opencti-appgw-test/
  ├── opencti-dev/
  ├── opencti-mgmt/
```

Each environment (`dev`, `test`, `mgmt`) contains its own variable files and backend configuration for state management, while the modules directory contains Terraform code to deploy OpenCTI components like Application Gateways, VMs, and more.

---

## 🚀 4. Deployment Instructions <a name="deployment-instructions"></a>

### 🧰 Set Up Azure Provider <a name="set-up-azure-provider"></a>

Ensure the Azure provider is properly configured in your `main.tf` or other relevant files. The provider will authenticate Terraform with your Azure subscription. This should already be present in the root module, but make sure the **subscription ID** and **authentication** are configured correctly.

### 🛠️ Configure Environment Variables <a name="configure-environment-variables"></a>

Update the environment-specific variable files (`terraform.tfvars`) located in each environment folder (`env/dev`, `env/test`, etc.). Customize parameters such as the resource group name, location, VM size, and App Gateway SKU for each environment.

For example:
- Resource Group: `"opencti-dev-rg"`
- Location: `"East US"`
- VM Size: `"Standard_D2_v3"`
- App Gateway SKU: `"WAF_Medium"`

Ensure that the **backend configuration** (`backend-config.tfvars`) for state storage is also correct in each environment, pointing to your Azure Blob storage account for centralized state management.

### 🔄 Deploy OpenCTI <a name="deploy-opencti"></a>

Once your variables and backend configuration are set, deploy OpenCTI by running the following Terraform commands from the **root directory**:

1. **Initialize Terraform**  
   Initialize the environment by specifying the backend configuration for state management:

   ```plaintext
   terraform init -backend-config=env/<environment>/backend-config.tfvars
   ```

2. **Plan the Deployment**  
   Preview the infrastructure changes Terraform will apply:

   ```plaintext
   terraform plan -var-file=env/<environment>/terraform.tfvars
   ```

3. **Apply the Deployment**  
   Deploy OpenCTI and related resources to Azure:

   ```plaintext
   terraform apply -var-file=env/<environment>/terraform.tfvars
   ```

Replace `<environment>` with `dev`, `test`, or `mgmt` as appropriate.

### 🧩 Deploy Specific Module From Root <a name="deploy-specific-module-from-root"></a>

To deploy a specific module (such as the Application Gateway for `dev`) without navigating into the module folder, use the `-target` option directly from the root directory:

1. **Initialize Terraform**  
   As usual, ensure you’ve initialized Terraform:

   ```plaintext
   terraform init -backend-config=env/<environment>/backend-config.tfvars
   ```

2. **Deploy the Specific Module**  
   Use the `-target` flag to deploy only the desired module:

   ```plaintext
   terraform apply -target=module.opencti-appgw-dev -var-file=env/dev/terraform.tfvars
   ```

This command targets only the `opencti-appgw-dev` module, ensuring that only the resources defined within that module are deployed, updated, or destroyed.

---

## 🔧 5. Terraform Commands <a name="comprehensive-terraform-commands"></a>

Here is a full list of useful Terraform commands you can run from the **root directory** for managing your infrastructure:

- **Initialize the environment**  
  Initializes the working directory and downloads the required provider plugins.
  ```plaintext
  terraform init -backend-config=env/<environment>/backend-config.tfvars
  ```

- **Preview changes**  
  Shows a detailed plan of changes without applying them.
  ```plaintext
  terraform plan -var-file=env/<environment>/terraform.tfvars
  ```

- **Apply changes**  
  Applies the planned changes to your Azure environment.
  ```plaintext
  terraform apply -var-file=env/<environment>/terraform.tfvars
  ```

- **Destroy resources**  
  Destroys all the resources managed by Terraform in the specified environment.
  ```plaintext
  terraform destroy -var-file=env/<environment>/terraform.tfvars
  ```

- **Deploy specific module**  
  Deploys a specific module using the `-target` option.
  ```plaintext
  terraform apply -target=module.<module-name> -var-file=env/<environment>/terraform.tfvars
  ```

- **Format the code**  
  Ensures consistent formatting of your Terraform files.
  ```plaintext
  terraform fmt
  ```

---

## 📈 6. Managing the Infrastructure <a name="managing-the-infrastructure"></a>

- **State Management**  
  Ensure your state files are safely stored in a remote backend (e.g., Azure Blob Storage). This is configured via the `backend-config.tfvars` file, ensuring shared access and avoiding state conflicts in team environments.

- **Scaling and Updating**  
  To scale OpenCTI instances or update configurations, modify the relevant environment-specific `terraform.tfvars` file and re-run the `terraform apply` command.

- **Rollbacks and Changes**  
  Terraform allows you to maintain the current state of your infrastructure in version-controlled files. If changes introduce issues, you can revert to previous configurations using version control and re-deploy using `terraform apply`.

---

## 🏆 7. Best Practices <a name="best-practices"></a>

- **Use Remote State**  
  Always use remote state storage to ensure consistency and avoid conflicts in multi-user environments.

- **Modular Approach**  
  Modularize your Terraform code to increase reuse and improve maintainability.

- **CI/CD Integration**  
  Integrate your Terraform configurations with CI/CD pipelines (e.g., GitHub Actions or Azure DevOps) for automated deployments and testing.

- **Version Control**  
  Commit your Terraform configuration files to Git to track and maintain your infrastructure as code.

- **Least Privilege Principle**  
  Ensure that the Azure resources and service principals have only the permissions necessary to perform their tasks.

---

## 🛠️ 8. Troubleshooting <a name="troubleshooting"></a>

While deploying OpenCTI on Azure using Terraform, you may encounter various issues. Below are some common problems, potential causes, and how to approach each.

### 🔐 **1. Authentication Issues**

Terraform may fail to authenticate with Azure services due to several reasons. These issues are often related to expired credentials or misconfigured authentication details.

- **Error Examples**: `Error building account`, `Invalid client credentials`, `Authentication failed`
- **Potential Causes**:
  - Expired Azure CLI session or invalid login.
  - Incorrectly set or expired Service Principal credentials.
  - Misconfigured environment variables (`ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`).

⚠️ **Note**: Always validate your Terraform configuration and ensure that you’ve correctly set your authentication details before proceeding.

---

### 🔒 **2. Terraform State Locking**

Terraform's state locking mechanism prevents multiple processes from modifying the state at the same time. Issues can arise if a previous operation was interrupted or if concurrent operations are initiated.

- **Error Examples**: `Error locking state`, `State is locked by another process`, `Failed to acquire state lock`
- **Potential Causes**:
  - A previous Terraform process was interrupted, leaving a stale lock.
  - Simultaneous Terraform runs are attempting to modify the same state file.
  - Network connectivity issues with remote backend storage (e.g., Azure Blob Storage).

💡 **Tip**: Ensure that only one Terraform process is running at any given time. If necessary, validate your state configuration and use the `terraform force-unlock` command to remove stale locks.

---

### 💡 **3. Resource Quota Limits**

Running into quota limits is a frequent issue when deploying cloud resources, especially in heavily utilized regions. Azure imposes limits on resources like virtual machines, storage, and IP addresses.

- **Error Examples**: `Quota exceeded for resource type`, `Not enough available resources in the region`
- **Potential Causes**:
  - The requested VM or resource type exceeds the allowed quota in the target region.
  - Incorrect resource sizing or an attempt to create too many instances at once.
  - Insufficient resources available in the selected Azure region due to high demand.

💬 **Detailed Considerations**: 
  - Before deploying, it’s essential to verify your region’s quota limits using the Azure portal. If needed, you can request quota increases from Azure Support. Additionally, ensure that you’re selecting the appropriate VM sizes and regions where resources are available.

📋 **Pro Tip**: Always check the limits in the Azure portal, especially when deploying to commonly used regions. Make sure your `terraform.tfvars` reflects realistic resource allocations.

---

### 💾 **4. Remote State Storage Issues**

If you're using remote state storage (e.g., Azure Blob Storage), Terraform may encounter problems accessing or writing to the backend due to connectivity issues or incorrect configuration.

- **Error Examples**: `Error retrieving the state from the backend`, `Failed to save state`, `Backend configuration error`
- **Potential Causes**:
  - Incorrect backend configuration in `backend-config.tfvars` (e.g., wrong storage account name or container).
  - Network issues between your local machine and the Azure Blob Storage account.
  - Insufficient permissions to read/write the state in the Azure Blob Storage container.

💻 **Important**: Double-check your backend configuration files and validate that the Service Principal or credentials used by Terraform have appropriate permissions (`Storage Blob Data Contributor`).

---

### ✅ **5. Validate Your Code**

Terraform's ability to validate the correctness of your infrastructure code is crucial for preventing runtime errors. Before running `terraform apply`, always validate your code.

- **Command**:  
  Run `terraform validate` to check for syntax and logical errors in your configuration files. This step ensures that your code is error-free before proceeding with deployment.

💡 **Reminder**: Always use `terraform fmt` to format your code consistently and `terraform validate` to catch issues early in your configuration.

---

## 📚 9. References <a name="references"></a>

- **[Terraform Official Documentation](https://www.terraform.io/docs)**
- **[Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)**
- **[OpenCTI Documentation](https://www.opencti.io/documentation)**

---