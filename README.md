+++
# 🚀 OpenCTI Azure Deployment with Terraform

Deploy OpenCTI on Azure with ease using Terraform. Follow these steps to quickly get started with different environments (`dev`, `test`, `mgmt`).

## ⚙️ Prerequisites

Before you begin, ensure the following:

- **[Terraform](https://www.terraform.io/downloads.html)** is installed.
- **[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)** is set up.
- You have an active **Azure Subscription**.

Start by logging into your Azure account:

```bash
az login
```

## 🚀 Deployment Steps

### 1️⃣ **Initialize and Validate** 🛠️

First, you need to set up Terraform by initializing the backend and ensuring everything is configured correctly. This step prepares Terraform to work with Azure and checks for any configuration issues:

```bash
terraform init -backend-config="env/dev/backend-config.tfvars"
terraform validate
```

- This will connect Terraform to your backend (for state files) and ensure that your configuration files are ready to go.

### 2️⃣ **Plan Your Deployment** 📋

Next, generate an execution plan. This will show you exactly what Terraform will do without making any changes yet:

```bash
terraform plan -var-file="env/dev/terraform.tfvars"
```

- Think of this step as a “dry run” where you can review the changes Terraform will make before applying them. It's an essential step to avoid surprises!

### 3️⃣ **Apply and Deploy** 🚀

Once you’re happy with the plan, go ahead and apply it to deploy your infrastructure. Terraform will prompt you for confirmation before proceeding:

```bash
terraform apply -var-file="env/dev/terraform.tfvars"
```

- Type `yes` to confirm the deployment. Now, Terraform will create all the resources as outlined in the plan.

### 4️⃣ **Destroy (Optional)** 🗑️

If you ever need to tear down your environment, simply run:

```bash
terraform destroy -var-file="env/dev/terraform.tfvars"
```

- This will remove everything Terraform created, giving you a clean slate.

## 🌍 Deploying in Different Environments

Switching between environments is simple. Just adjust the paths:

- **Test Environment** 🧪
  ```bash
  terraform init -backend-config="env/test/backend-config.tfvars"
  terraform plan -var-file="env/test/terraform.tfvars"
  terraform apply -var-file="env/test/terraform.tfvars"
  ```

- **Management Environment** ⚙️
  ```bash
  terraform init -backend-config="env/mgmt/backend-config.tfvars"
  terraform plan -var-file="env/mgmt/terraform.tfvars"
  terraform apply -var-file="env/mgmt/terraform.tfvars"
  ```

## 🛠️ Useful Terraform Commands

Here are some helpful commands to make your deployment smoother:

- **Enable Debug Logging** 🐛: Get more detailed logs when troubleshooting:
  ```bash
  TF_LOG=DEBUG terraform plan -var-file="env/dev/terraform.tfvars"
  ```

- **Auto-Approve** ✔️: Automatically apply changes without needing manual confirmation:
  ```bash
  terraform apply -auto-approve -var-file="env/dev/terraform.tfvars"
  ```

- **Refresh State** 🔄: Sync Terraform’s state file with your actual Azure resources:
  ```bash
  terraform refresh -var-file="env/dev/terraform.tfvars"
  ```

- **Inspect Resources** 🔍: View detailed information about your deployed resources:
  ```bash
  terraform show
  ```

## 🔧 Troubleshooting Tips

- **Azure Login Issues**: If you encounter issues, ensure you’re logged in with `az login`.
- **Backend Issues**: Double-check that your backend storage (like Azure Storage accounts) is correctly configured and accessible.
- **Configuration Errors**: Run `terraform validate` to catch issues early and review your `terraform.tfvars` for any missing values.

## 🎉 Conclusion

With these steps, you can deploy OpenCTI on Azure confidently and efficiently using Terraform. Customize the commands for your specific environment, and enjoy the power of automated infrastructure management. For more help, feel free to open an issue on GitHub. Happy deploying! 🚀
+++