# LS Central - Offline POS Sending Transactions overview dashboard

## Overview

This repository contains a dashboard designed to monitor and analyze how transactions created during offline POSes in LS Central are replicated back to Head Office environment.

The dashboard provides visibility into the end-to-end flow of offline transactions, helping users ensure data consistency, identify delays, and troubleshoot replication issues.

The current dashboard is built for use in Azure Data Explorer, where telemetry data can be queried and visualized to provide operational insight into the transactions replication process.

To support the dashboard, we implemented a custom telemetry event that tracks the transaction flow across its different stages. This event is included in the AL extension provided in the repository.

## Supported Replication Methods

> **Important:** This dashboard is a proof of concept and currently supports only the **Sending Transactions using Storage Queue** replication method. Additional replication methods may be added in future iterations.

## What's Included

| Item | Path | Description |
|------|------|-------------|
| Dashboard definition | `azure-data-explorer-dashboard/dashboard.json` | Azure Data Explorer dashboard JSON file to import |
| Telemetry AL extension | `al-telemetry-app/LS Retail - CAP_Replication Telemetry_1.0.0.0.app` | AL extension that emits the telemetry events used by the dashboard |
| POS mapping sample | `azure-data-explorer-dashboard/data/pos-mapping.csv` | Example CSV file mapping Offline POS terminals |
| Documentation | `docs/` | Installation guide and reference documentation |

## Cost Considerations

This solution has a **minimal Azure cost**. Because Azure Data Explorer reads telemetry data directly from Application Insights, **no Azure Data Explorer cluster is required**. A cluster would be the only source of meaningful monthly compute cost; without one, that cost is eliminated entirely.

The only Azure costs associated with running this dashboard are:

### 1. Azure Storage Account (POS Mapping CSV)

The `pos-mapping.csv` file is a tiny file (typically 5–50 KB). At Azure Blob Storage Hot/LRS pricing (~$0.02–$0.023 per GB/month), the storage cost is effectively:

```
50 KB / 1 GB × $0.023 ≈ $0.000001/month
```

Read operations (a few per day from the dashboard) add at most ~$0.0001/month.

**In practice, the Azure Storage cost rounds to $0.00/month for all budgeting purposes.**

### 2. Application Insights Telemetry Ingestion

Application Insights includes a **free 5 GB of data ingestion per month**. Beyond that, additional data is billed at a pay-per-use rate - but only if ingestion exceeds the free tier.

This cost is not specific to the dashboard - it is the cost of having telemetry enabled at all, regardless of whether the dashboard is used.

---

## Installation

For instructions on how to set up the dashboard environment, see the [Installation Steps](docs/Installation-Steps.md).
