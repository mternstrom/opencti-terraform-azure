
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

- **OpenCTI Docker Configuration** ready for containerized deployment of OpenCTI on Azure

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

## 🔧 5. Comprehensive Terraform Commands <a name="comprehensive-terraform-commands"></a>

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

- **Authentication Errors**  
  If you encounter authentication issues, ensure that your Azure credentials are correctly configured and that the service principal has appropriate permissions in the Azure subscription.

- **State Locking**  
  If Terraform reports a state lock, verify if another process is applying changes. Remove stale state locks from your Azure Blob Storage if necessary.

- **

Resource Limits**  
  Review Azure subscription quotas and ensure your deployments stay within the available resource limits. Adjust limits as needed via the Azure portal.

---

## 📚 9. References <a name="references"></a>

- **[Terraform Official Documentation](https://www.terraform.io/docs)**
- **[Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)**
- **[OpenCTI Documentation](https://www.opencti.io/documentation)**

---