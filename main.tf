terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  
    /*azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }*/

  }

  required_version = ">= 1.2.0"

  cloud {
    organization = "main_romanzamora"

    workspaces {
      name = "TFC_Value_Demo"
    }
  }

}

/****************************/
/* Providers */

provider "aws" {
  region = "eu-west-1"
}

/*provider "azurerm" {
  features {}
}*/


/****************************/
/* Resources */


/* AWS  */
resource "aws_instance" "app_server" {
  ami           = "ami-0ef9e689241f0bb6e"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.example_security_group.id]
  
  tags = {
    Name = "TFC-Value-Demo-App-server"
  }
}

resource "aws_security_group" "example_security_group" {
  name        = "TFC-Value-Demo-SG"
  description = "Allow ICMP (ping) traffic only"
  
  ingress {
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow ICMP from any IP
  }
}

output "instance_ip" {
  value = aws_instance.app_server.public_ip
  description = "The public IP address of the EC2 instance"
}

/* AZURE */

/*
resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = "francecentral"
}


resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVNet2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "myTFSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "myTFNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myTFNICConfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "app_server" {
  name                  = "ExampleAppServerInstance"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "Password1234!"  # Change this to a strong password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  tags = {
    environment = "production"
  }
}
*/