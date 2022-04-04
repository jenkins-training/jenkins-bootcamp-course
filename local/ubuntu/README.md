# Jenkins Installation

## Purpose

This guide will help setup a Jenkins server quickly on Ubuntu Server 20.04 LTS.

## Requirements

* Ubuntu 20.04 LTS (tested with server) - x86/amd64 or Arm64
* Networking working

## Included

The following items will be installed/setup:

* Basic tools like zip, nano, git
* OpenJDK 11 (headless)
* Jenkins (server)
* Nginx
    * Add reverse proxy config to point to Jenkins server

## Jenkins Server Setup

Run (copy and paste) the following command in the Terminal in your Ubuntu server:

```bash
sudo bash -c "$(wget -q https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/main/local/ubuntu/jenkins-server-only.sh -O -)"
```