# Developer Onboarding Guide

Welcome to the CDN-Biceps project! This guide will help new contributors get started quickly and efficiently.

## Project Overview
- Automates Azure CDN and Storage deployment using Bicep
- Delivers a public JSON file via CDN with cache bypass
- Follows best practices for security and workflow

## Prerequisites
- Azure subscription
- Azure CLI installed
- Bicep CLI installed
- Git installed

## Repository Structure
- `infra/`: Bicep templates and sample files
- `docs/`: Documentation and best practices
- `.github/`: Workflow, instructions, and templates

## Setup Steps
1. **Clone the repository**
   ```pwsh
   git clone https://github.com/abhishek0412/CDN-Biceps.git
   cd CDN-Biceps
   ```
2. **Install Azure CLI and Bicep CLI**
   - [Azure CLI Installation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
   - [Bicep CLI Installation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
3. **Authenticate with Azure**
   ```pwsh
   az login
   ```
4. **Deploy resources**
   ```pwsh
   az deployment group create --resource-group <your-resource-group> --template-file infra/main.bicep
   ```

## Workflow Rules
- All changes via Pull Requests (PRs)
- No direct pushes to `main`
- At least one reviewer required
- Branches must be up-to-date before merging
- Status checks enabled if CI/CD is configured

## Contribution Steps
1. **Create a feature branch**
   ```pwsh
   git checkout -b feature/your-feature
   ```
2. **Make your changes and commit**
   ```pwsh
   git add .
   git commit -m "Describe your change"
   ```
3. **Push your branch**
   ```pwsh
   git push origin feature/your-feature
   ```
4. **Open a Pull Request**
   - Use the PR template
   - Reference related issues
   - Complete all checklist items

## Additional Resources
- [Azure CDN Documentation](https://docs.microsoft.com/en-us/azure/cdn/)
- [Azure Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Best Practices](./best-practices.md)

## Contact
For questions, open an issue or contact a maintainer.
