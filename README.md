---

# ![OpenCTI Logo](https://example.com/opencti-logo.png) OpenCTI Deployment on Azure using Terraform

This guide details how to deploy **OpenCTI on Microsoft Azure** using **Terraform**. The following instructions cover the creation of necessary Azure resources (like VMs, networking, and databases) to support OpenCTI in different environments (Development, Testing, and Management).

---

## 📜 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Folder Structure Overview](#folder-structure-overview)
3. [OpenCTI Deployment on Azure](#opencti-deployment-on-azure)
4. [Managing Infrastructure](#managing-infrastructure)
5. [Useful Terraform Commands](#useful-terraform-commands)
6. [Best Practices](#best-practices)
7. [Support](#support)

---

## ⚙️ Prerequisites <a name="prerequisites"></a>

Before proceeding with the deployment, ensure the following tools are installed on your system:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

Additionally, make sure:
- You have access to an Azure subscription.
- Necessary permissions are granted for resource provisioning.
- Terraform state is stored remotely using Azure Blob Storage (configured in backend files).

---

## 🗂️ Folder Structure Overview <a name="folder-structure-overview"></a>

```plaintext
root
│
├── env/
│   ├── dev/
│   │   └── terraform.tfvars
│   ├── test/
│   │   ├── backend-config.tfvars
│   │   └── terraform.tfvars
│   └── mgmt/
│       ├── backend-config.tfvars
│       └── terraform.tfvars
│
├── modules/
│   ├── opencti-appgw-dev/
│   ├── opencti-appgw-mgmt/
│   ├── opencti-appgw-test/
│   ├── opencti-dev/
│   └── opencti-mgmt/
│
└── main.tf
```

---

## 🚀 OpenCTI Deployment on Azure <a name="opencti-deployment-on-azure"></a>

### Step 1: Configure Environment Variables

Each environment (Dev, Test, Mgmt) has its own `terraform.tfvars` file, which contains the Azure-specific configurations, like the resource group, region, and other required variables.

#### Example `terraform.tfvars` for Dev:

```hcl
location             = "eastus"
resource_group_name  = "rg-opencti-dev"
subscription_id      = "your-subscription-id"
opencti_vm_size      = "Standard_DS2_v2"
opencti_vm_name      = "opencti-dev-vm"
opencti_vm_username  = "azureuser"
opencti_vm_password  = "Password123!"
network_security_group_name = "opencti-dev-nsg"
virtual_network_name = "opencti-dev-vnet"
subnet_name          = "opencti-dev-subnet"
```

This configuration defines the Azure region, resource group, virtual machine specifications, and network settings for the **Dev** environment.

### Step 2: Backend Configuration for Remote State

Ensure that your `backend-config.tfvars` is properly set up to store the Terraform state remotely in an Azure storage account.

#### Example `backend-config.tfvars` for Dev:

```hcl
storage_account_name = "yourstorageaccount"
container_name       = "tfstate"
key                  = "dev.terraform.tfstate"
```

This configuration ensures that the state file is stored securely in the specified storage account and container.

### Step 3: Initialize Terraform

In the root directory, initialize Terraform to prepare for deployment:

```bash
terraform init -backend-config="env/dev/backend-config.tfvars"
```

This command sets up Terraform with the backend configuration for state storage.

### Step 4: Plan the Deployment

Generate a plan to preview the infrastructure changes Terraform will make:

```bash
terraform plan -var-file="env/dev/terraform.tfvars"
```

This command allows you to verify the resources that will be created in Azure for OpenCTI.

### Step 5: Apply the Deployment

Apply the Terraform plan to deploy the OpenCTI infrastructure on Azure:

```bash
terraform apply -var-file="env/dev/terraform.tfvars"
```

The infrastructure is deployed, including virtual machines, networking components, and security groups configured specifically for OpenCTI.

Once complete, the OpenCTI resources will be provisioned in Azure according to your configuration.

---

## 🔧 Managing Infrastructure <a name="managing-infrastructure"></a>

### Updating the Infrastructure

If there are changes to the infrastructure (e.g., increasing VM size or adding new networking rules), update the configurations in your `.tfvars` files and then run:

```bash
terraform plan -var-file="env/dev/terraform.tfvars"
terraform apply -var-file="env/dev/terraform.tfvars"
```

This will apply the changes to your existing OpenCTI deployment in Azure.

### Destroying the Infrastructure

If you need to tear down the infrastructure, you can do so with the following command:

```bash
terraform destroy -var-file="env/dev/terraform.tfvars"
```

This will remove all the resources provisioned for OpenCTI in the Dev environment.

Repeat the steps for other environments (Test, Mgmt) by changing the paths to the respective environment files.

---

## 🛠️ Useful Terraform Commands <a name="useful-terraform-commands"></a>

Here are some essential Terraform commands for managing your OpenCTI deployment:

- **Initialize Terraform**:
  ```bash
  terraform init -backend-config="env/dev/backend-config.tfvars"
  ```
- **Generate and review an execution plan**:
  ```bash
  terraform plan -var-file="env/dev/terraform.tfvars"
  ```
- **Apply changes to the infrastructure**:
  ```bash
  terraform apply -var-file="env/dev/terraform.tfvars"
  ```
- **Destroy infrastructure**:
  ```bash
  terraform destroy -var-file="env/dev/terraform.tfvars"
  ```
- **Check the current state of the infrastructure**:
  ```bash
  terraform show
  ```

---

## 📈 Best Practices for OpenCTI on Azure <a name="best-practices"></a>

1. **Use Remote State Management**: Store Terraform state files securely in an Azure Blob Storage account to prevent data loss and enable collaboration.
2. **Keep Variables Modular**: Organize your configurations by environment to ensure that Dev, Test, and Mgmt environments can be independently managed and deployed.
3. **Version Control**: Use Git to track and manage changes to your Terraform configurations, allowing for consistent deployments across teams.
4. **Use Separate Environments**: Clearly separate environments (Dev, Test, Mgmt) to avoid accidental deployments or changes across environments.
5. **Automate**: Integrate Terraform with CI/CD pipelines for automated deployments and updates to the OpenCTI infrastructure on Azure.

---

## 🛠️ Support <a name="support"></a>

For assistance with this OpenCTI deployment, refer to:

- [Terraform Documentation](https://learn.hashicorp.com/terraform)
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- [OpenCTI Documentation](https://www.opencti.io/docs)

---

![Azure and Terraform Logos](https://example.com/azure-terraform-logos.png)

---