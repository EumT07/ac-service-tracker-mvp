# ❄️ AC Service Tracker: Air Conditioning Maintenance Management System

## 📝 Project Description

**Ac Service Tracker MVP** is a specialized **CRM (Customer Relationship Management)** and **CMMS (Computerized Maintenance Management System)** designed to optimize the cleaning and maintenance service for air conditioning units.

### 🎯 Key Features (MVP)

* **Client and Asset Management:** Centralizes information about clients and their installed A/C units.
* **Maintenance Scheduling:** Facilitates the creation and tracking of **Preventive and Corrective Maintenance** tasks.
* **Inventory Control:** Basic management of spare parts and cleaning supplies.
* **Analytics Dashboard:** Offers key metrics (MTBF, corrective rates) derived from my Industrial Maintenance Engineering experience.
* **Notification Automation:** Integration with **n8n** for automated management of new service requests and reminders.

### 🛠️ Tech Stack

| Component | Technology |
| :--- | :--- |
| **Backend (API)** | **Python (Django)** |
| **Database** | **PostgreSQL** |
| **Frontend** | HTML5, CSS, JavaScript (Vanilla/Lightweight Library) |
| **Data Analysis** | Pandas and Matplotlib |
| **Automation** | n8n |

## ⚙️ Using: UV

1. **Clone the repository**
  ```bash
   git clone https://github.com/EumT07/ac-service-tracker-mvp.git
   cd ac-service-tracker-mvp
   ```
2. **Create virtual environment**
  ```bash
  uv venv
  ```
3. **Install dependencies**
  ```bash
  uv pip install -r pyproject.toml
  ```
  or
  ```bash
  uv  sync
  ```

  ## ⚙️ Using: Pip

1. **Clone the repository**
  ```bash
   git clone https://github.com/EumT07/ac-service-tracker-mvp.git
   cd ac-service-tracker-mvp
   ```
2. **Create virtual environment**
  ```bash
  python -m venv .venv
  ```
3. **Activate virtual environment**
    # On Windows:
    ```bash
    .venv\Scripts\activate
    ```
    # On macOS/Linux:
    ```bash
    source .venv/bin/activate
    ```

4. **Install dependencies**
  ```bash
  pip install -e .
  ```

Author: Eublan Mata

<p align="center">
  <img src="https://github.com/EumT07/ac-service-tracker-mvp/blob/master/assest/maintenance.webp" width="450" height="300"  alt="home" />
</p>
