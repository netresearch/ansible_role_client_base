# Client-Base Ansible Role

This Ansible role provides a basic setup for Linux based clients.

Currently supported platforms:

- Ubuntu 24.04 LTS	Noble Numbat
- Ubuntu 22.04 LTS	Jammy Jellyfish

What does this role do?
- installs certificates
- installs to trusted browser certificate store
- set **IOT** number as **hostname**
- adds **admin** user account
- adds **user** account
- installs **standard software** packages and flatpaks

## Requirements
Ansible >= 2.16.0

## Role Variables

| Name           | Default Value | Description                        |
| -------------- | ------------- | -----------------------------------|
| `hostname` | `iot-xx` | Desired client hostname. |
| `domainname` | `example.com` | Client's domain name to get the FQDN. |
| `adminname` | `admin` | Desired admin name. |
| `adminpassword` | `Newpassword123$` | Client's administrator password. |
| `username` | `newuser` | Name for the new user. |
| `userpassword` | `newuserpassword` | Password for the new user. |
| `force_libssl_downgrade` | `false` | To determine if uninstalling the libssl-dev package is forced. |
| `skip_check_prompts` | `false` | To skip user prompts. Only set to true in the testplaybook. |


## Applying the role

### 1. Apply the Role Directly on the Target Machine

You can apply the Ansible role directly on the target machine by running the playbook locally. Ensure that the target machine is accessible and the necessary dependencies are installed on the local machine.

#### Prerequisites:
- Install Git and Ansible on your local machine.
    ```bash
    pip install git ansible
    ```

#### Steps:
1. Clone `ansible_role_client_base` - Gitlab token required
    ```bash
    cd ~
    git clone https://git.netresearch.de/provision/ansible_role_client_base.git
    ```

2. Navigate to the directory containing your `site.yml` playbook:
    ```bash
    cd ~/ansible_role_client_base
    ```

3. Run the playbook locally to apply the `ansible_role_client_base` role to the target machine:
    ```bash
    ansible-playbook site.yml
    ```

### 2. Apply the Role Remotely via SSH

#### Prerequisites:
- Ansible, git and sshpass installed on your local machine.
    ```bash
    sudo apt install sshpass python3
    pip install ansible git
    ```
- The initial user account on the target Ubuntu machine should be **admin1**
- Ensure that SSH password authentication is enabled on the target Ubuntu machine 
   ```bash
   sudo nano /etc/ssh/sshd_config
   
   PasswordAuthentication yes
   ```

- Don't forget to disable it after the role is applied
   ```bash
   sudo nano /etc/ssh/sshd_config
   
   #PasswordAuthentication yes
   ```

#### Steps:

1. Clone `ansible_role_client_base`
    ```bash
    cd ~
    git clone https://github.com/netresearch/ansible_role_client_base

2. Navigate to the directory containing your `site.yml` playbook:
    ```bash
    cd ~/ansible_role_client_base
    ```

3. Edit the `site.yml` file (if necessary) to specify the correct `hosts` and `become` settings for your remote machine.

4. Run the playbook remotely by specifying the target machine's IP address or hostname in the `-i` option:
    ```bash
    ansible-playbook site.yml -i <your_target_machine_ip> --ask-become-pass --ask-pass
    ```

   Replace `your_target_machine_ip` with the actual IP or hostname of the target machine. 
   The `--ask-become-pass` flag will prompt you for the password if you are using `sudo` (become).
   The `--ask-pass` flag will prompt you for **admin1** user password.

   This will connect to the target machine over SSH and apply the role.

### 3. Container Usage

An example playbook site.yml is included here for testing purposes. 

The initial user account on the target Ubuntu machine should be **admin1**

To run the Ansible role from a Docker container, use the following command:

```bash
docker run -it -e ANSIBLE_HOST_KEY_CHECKING=false ghcr.io/netresearch/ansible_role_client_base:latest ansible-playbook site.yml -i <your_target_machine_ip>, --ask-pass --ask-become-pass

```
   Replace `your_target_machine_ip` with the actual IP or hostname of the target machine. 
   The `--ask-become-pass` flag will prompt you for the password if you are using `sudo` (become).
   The `--ask-pass` flag will prompt you for **admin1** user password.

   This will connect to the target machine over SSH and apply the role.

## Testing

### Testing with Molecule

#### Prerequisites

* **Python**: Ensure Python is installed.
* **Docker**: Required for Molecule tests with Docker.
  * https://docs.docker.com/engine/install/
* **Ansible**: Ansible must be installed for running playbooks

```bash
sudo apt install sshpass python3
```

#### Running the tests

1. Create a Python Virtual Environment and activate it
   ```bash
   python -m venv ansible-env
   source ansible-env/bin/activate
   pip install --upgrade pip
   ```

2. Install the necessary Python packages in your virtual environment:
   ```bash
   pip install -r requirements.txt
   ```

3. Run Molecule Commands
   ```bash
   # Create: Sets up Docker containers for testing.
   molecule create

   # Converge: Applies the role to the test containers.
   molecule converge

   # Destroy: Removes Docker containers after testing.
   molecule destroy

   # Test: Runs the complete test lifecycle, including create, converge, verify, and destroy.
   molecule test
   ```

## Ubuntu Software List for Custom Installation

A curated list of essential software for Ubuntu, categorized into **General Tools/Utilities** and **Developer Tools**, with brief descriptions and relevance notes.

## General Tools/Utilities

1. **`wget`**  
   **Description**: Command-line tool for downloading files from the internet via HTTP, HTTPS, and FTP.  
   **Relevance**: Essential for scripting and downloading files in a Linux environment.

2. **`curl`**  
   **Description**: Command-line tool for transferring data using URL syntax, supporting various protocols.  
   **Relevance**: Crucial for interacting with APIs and downloading content.

3. **`p7zip-full`**  
   **Description**: A high-compression file archiver that supports multiple formats (7z, ZIP, TAR, GZ, etc.).  
   **Relevance**: Essential for handling compressed files.

4. **`chromium`**  
   **Description**: A fast, secure web browser with excellent web standards support.  
   **Relevance**: Popular choice for those who need Google account synchronization.

5. **`firefox`**  
   **Description**: Privacy-focused, open-source web browser with customizable features.  
   **Relevance**: Default browser on Ubuntu and widely supported.

6. **`bitwarden`**  
   **Description**: Open-source password manager for secure login credentials management.  
   **Relevance**: Highly recommended for secure password storage.

7. **`libreoffice`**  
   **Description**: Free, open-source office suite with tools for word processing, spreadsheets, and presentations.  
   **Relevance**: Essential for office tasks on Linux.

8. **`flameshot`**  
   **Description**: Modern screenshot tool for taking and annotating screenshots.  
   **Relevance**: Superior alternative to basic screenshot tools.

9. **`vlc`**  
   **Description**: A versatile media player supporting a wide range of audio and video formats.  
   **Relevance**: One of the best options for media playback.

10. **`element`**  
    **Description**: Secure messaging platform built on the Matrix protocol for decentralized communication.  
    **Relevance**: Essential for privacy-conscious teams.

11. **`rclone`**  
    **Description**: Command-line tool for managing cloud storage services, including Google Drive.  
    **Relevance**: Modern, robust alternative to older tools for managing cloud storage.

12. **`cifs-utils`**  
    **Description**: Utilities for mounting and managing SMB/CIFS network shares.  
    **Relevance**: Needed for connecting to legacy systems using SMB.

---

## Developer Tools

1. **`git`**  
   **Description**: Distributed version control system for tracking changes in source code.  
   **Relevance**: Fundamental tool for developers.

2. **`python3`**  
   **Description**: Python programming language for scripting, automation, and application development.  
   **Relevance**: Necessary for most development work on Ubuntu.

3. **`code` (Visual Studio Code)**  
   **Description**: Lightweight, extensible code editor supporting multiple programming languages and extensions.  
   **Relevance**: Essential for most developers.

4. **`phpstorm`**  
   **Description**: A powerful IDE for PHP development with advanced features like debugging and version control integration.  
   **Relevance**: Recommended for PHP developers; optional for others.

5. **`filezilla`**  
   **Description**: Open-source FTP client for transferring files between local machines and remote servers.  
   **Relevance**: A must-have for developers working with remote servers.

6. **`docker`**  
 **Description:** Platform for developing, deploying, and managing containerized applications.  
  **Relevance:** Crucial for developers working with microservices or containerized environments.  
  **Note:** This role does not install Docker. It is recommended to use the [geerlingguy.docker](https://github.com/geerlingguy/ansible-role-docker) role to install Docker.

8. **`wireguard`**  
   **Description**: A modern, fast, and secure VPN protocol.  
   **Relevance**: Useful for developers needing secure remote access or networking.