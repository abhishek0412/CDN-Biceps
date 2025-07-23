---
post_title: Azure CDN Static File Delivery
author1: abchoudhary
post_slug: azure-cdn-static-file-delivery
microsoft_alias: abchoudhary
featured_image: https://docs.microsoft.com/en-us/azure/cdn/media/cdn-overview.png
categories: [azure, infrastructure, cdn]
tags: [cdn, bicep, azure, static-files, deployment]
ai_note: true
summary: This project provisions Azure CDN and Storage resources using Bicep to securely deliver a public JSON file with automated deployment and cache bypass.
post_date: 2025-07-23
---

## Project Overview

This project automates the deployment of Azure CDN and Storage resources using Bicep. It enables secure, public delivery of a sample JSON file via CDN, with cache bypass and static resource naming for predictable access.

## Features

- Static resource names for all Azure resources
- Storage account and blob container in East US
- Azure CDN profile and endpoint for global delivery
- Automated upload of a sample JSON file using deployment scripts
- CDN cache bypass for real-time file delivery
- Managed identity and RBAC for secure automation

## Architecture

- **Storage Account**: Hosts the public blob container and sample JSON file
- **Blob Container**: Configured for public read access to blobs only
- **CDN Profile & Endpoint**: Delivers the file globally, bypassing cache
- **Deployment Script**: Uploads the JSON file at deployment time
- **Managed Identity**: Secures script access to storage

## Usage

1. Clone the repository.
2. Update resource names in `infra/main.bicep` if needed.
3. Deploy using Azure CLI:

```pwsh
az deployment group create --resource-group CrestAvenue-EUEU --template-file infra/main.bicep
```

4. Access the file via CDN:

```
https://crestavenuecdnendpoint.azureedge.net/publicfiles/sample.json
```

## File Structure

- `infra/main.bicep`: Bicep template for all resources and automation
- `infra/sample.json`: Example JSON file content
- `.github/instructions/markdown.instructions.md`: Markdown and documentation standards

## Security Notes

- Only the sample file is public; users cannot list or modify other files
- Managed identity is used for secure automation
- No secrets or keys are exposed in outputs

## License

This project is provided under the MIT License.

## References

- [Azure CDN Documentation](https://docs.microsoft.com/en-us/azure/cdn/)
- [Azure Bicep Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
