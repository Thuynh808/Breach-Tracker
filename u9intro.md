<div class="flex-container">
        <img src="https://github.com/ProfessionalLinuxUsersGroup/img/blob/main/Assets/Logos/ProLUG_Round_Transparent_LOGO.png?raw=true" width="64" height="64"></img>
    <p>
        <h1>Unit 9: Containerization with Podman on Linux</h1>
    </p>
</div>

<br><br>
## Overview

In this unit, we dive into the modern world of containerization, focusing on Podman—an open-source, daemon-less container engine. As Linux administrators, understanding containerization is crucial for supporting developers, managing production systems, and deploying services efficiently.

You’ll explore what containers are, how to manage them, and how to build container images.


## Relevance & Context

Containerization is a critical part of modern IT, powering development pipelines (CI/CD), cloud deployments, and microservices. As Linux system administrators, we are expected to support and troubleshoot containers, manage container infrastructure, and ensure smooth operations across development and production environments.

This unit focuses on Podman, a secure, rootless, and daemon-less alternative to Docker, widely used in enterprise environments like Red Hat and Rocky Linux. Whether you work in a NOC, DevOps, or traditional SysAdmin role, understanding containerization is essential to being an effective part of any IT team.

## Learning Objectives

By the end of this unit, you will be able to:

- Explain what containers are and how they fit into modern Linux system administration
- Differentiate between Docker and Podman, including security and architectural considerations
- Run and manage Podman containers, including starting, stopping, and inspecting containers
- Build custom container images using Dockerfiles and Podman
- Analyze container processes, logs, and network interactions for troubleshooting
- Understand real-world use cases, including development, production, and CI/CD pipeline integration

## Prerequisites

Before starting Unit 9, you should have:

- Basic understanding of Linux command line and shell operations
- Familiarity with package management and system services on RHEL-based systems (Rocky/Red Hat)
- Root or sudo access to a Linux system (Rocky 9 or equivalent)
- Completed previous units on system administration fundamentals (file permissions, processes, networking)
- Optional but recommended: Initial exposure to virtualization or application deployment concepts

## Topics Covered

- What are Containers? Overview and definitions
- Introduction to Docker and Podman – key differences
- Managing Podman containers:
  - Running, stopping, and inspecting containers
  - Working with Podman images
  - Networking and port mapping
  - Analyzing container logs and processes
- Building container images using Dockerfiles
- Containers in development vs. production (Dev/Prod) environments
- CI/CD pipelines and how containers fit into modern software delivery
- Common troubleshooting scenarios

## Key Activities

- **Warm-up exercises**:
  - Familiarizing with Podman installation and basics

- **Hands-on lab**:
  - Building and running Podman containers
  - Examining container internals: logs, processes, and configurations
  - Troubleshooting common issues using real command outputs
  - Building a custom application image with Podman and Dockerfile

- **Discussion Posts to apply critical thinking**:
  - Reflecting on container benefits and challenges
  - Diagnosing real-world container issues

- **Digging Deeper**:
  - Deploying a service or application of your choice in a container
  - Playing with K3s as an introduction to Kubernetes and orchestration
  - Reflection questions to assess understanding and practical application

## Resources & Important Links

- **Podman Official Documentation**: https://podman.io/docs
- **Dockerfile Reference**: https://docs.docker.com/build/concepts/dockerfile/
- **Podman Exec Documentation**: https://docs.podman.io/en/latest/markdown/podman-exec.1.html

## Next Steps

- Start with the Worksheet: Reflect on container use cases and challenges
- Complete the Lab: Gain hands-on skills with Podman
- Engage in Discussions: Share insights and troubleshoot scenarios
- Explore "Digging Deeper": Take on a deployment challenge to expand your skills
