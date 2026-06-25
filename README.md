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

## Installation

For instructions on how to set up the dashboard environment, see the [Installation Steps](docs/Installation-Steps.md).
