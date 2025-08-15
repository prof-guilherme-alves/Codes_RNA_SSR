# A Novel Methodology for Determining Steady-State Security Regions Using Artificial Neural Networks in Near Real-Time Applications

This repository contains the datasets and MATLAB scripts used to reproduce the results of the paper ID 9807, accepted for publication in the IEEE Latin America Transactions.

**Authors:**
- Guilherme de Oliveira Alves
  - Federal Center for Technological Education Celso Suckow da Fonseca (CEFET/RJ), Brazil
  - Contact: `guilherme.alves@cefet-rj.br`
- João Alberto Passos Filho
  - Federal University of Juiz de Fora (UFJF), Brazil
  - Contact: `joao.passos@ufjf.br`
  
---
## 📁 Repository Structure

The main directory contains two folders, one for each test system:

- **IEEE 9-Bus System**
- **New England System**

Inside each test system folder, there are 5 subfolders corresponding to each SSR limit:
- **MVAR** – Reactive power generation limits  
- **MW** – Active power generation group limit  
- **Security** – Maximum active power transfer  
- **Thermal** – Thermal limits in series components  
- **Voltage** – Voltage magnitude limits in all buses  

---

## 📑 Contents of Each Limit Folder

Each limit folder contains the following files:

- Spreadsheet containing the training dataset for the respective SSR limit.
- Spreadsheet containing the load curve data for SSR estimation according to the limit.  
- `bayesian_search.m` – Finds the best neural network architecture using **Bayesian search** (number of hidden layers and neurons per layer).  
- `training_rna.m` – Trains the neural network with the training data.  
  > You must manually update the results according to the architecture found by the Bayesian search (line 36) if you wish to use or find a configuration different from the one presented in the paper (default).  
- `ssr_limits.m` – Estimates the coordinates for the SSR limit and generates the corresponding plot.

---

## 📈 Plotting the Complete SSR

To plot the full SSR:

1. Use the `data_plot_graphic.xlsx` file and the `plot_ssr.m` script, located in the same directory as the limit subfolders.  
2. Update `data_plot_graphic.xlsx` with the coordinates of each limit obtained from `ssr_limits.m`.  
   - Each **column** in the spreadsheet represents one SSR limit.
   - By default, the coordinates for the load curve times presented in the paper are used.  
3. Run `plot_ssr.m` to generate the SSR plot.  
   - Update the **operating point** (lines 18–22) according to the desired load curve time.  
   - By default, the times shown in the paper are used.  
   - You may need to adjust **scales** and **graph formatting**.

---

## 📝 Descriptive Files

- `data_training_columns_description.txt` – Explain each column in the spreadsheet that contains the training dataset.
- `data_load_curves_columns_description.txt` –  Explain each column in the spreadsheet that contains the load curve data.

---

## 🖥️ Requirements

- MATLAB (tested on version R2018a)
- Excel or compatible software for .xlsx files

