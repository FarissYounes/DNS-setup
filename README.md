# Terraform Setup for Google Cloud Platform (GCP)

This Terraform configuration sets up a GCP environment with the following components:
- A static external IP address.
- A firewall rule allowing all incoming traffic.
- A compute instance running Debian 11 with SSH access configured.

## Requirements

1. **Terraform**: Install Terraform on your system. Follow the [official installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
2. **GCP Service Account Key**: A JSON key file for a service account with the necessary permissions.

## Setup Instructions

### Step 1: Prepare the Terraform Files

1. Save the Terraform configuration code in a file named `main.tf` in your project directory.

### Step 2: Create the `key.json` File

1. Go to the Google Cloud Console.
2. Create a service account with sufficient permissions.
3. Download the JSON key file for the service account and save it as `key.json` in the root directory of your Terraform project.

### Step 3: Generate SSH Keys

1. Generate an SSH key pair for the instance:
   ```bash
   ssh-keygen -t rsa -b 2048 -f ./ssh-key/key
