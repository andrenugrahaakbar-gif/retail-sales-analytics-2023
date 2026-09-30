# 🛒 Retail Sales Analytics 2023

**Diagnosing a 2.3× revenue swing across 5 stores and 3 product categories.**

A data analytics project using SQL, Python, and Power BI to uncover *why* revenue
fluctuated sharply in 2023 — and what actions management should prioritize.

---

## 🎯 Problem

A multi-store retail company saw revenue swing from **$20.7K (September)** to
**$47.5K (May)** with no clear seasonal pattern. Management didn't know whether
the swings came from **volume**, **traffic**, **pricing**, or **specific
categories/stores**.

## ✅ What I Did

- Cleaned and prepared **947 transactions** (Python / Pandas)
- Built a **Revenue Decomposition** framework: `Revenue = Transactions × Units/Transaction × Revenue/Unit`
- Aggregated data in **PostgreSQL** to drill down by month, category, and store
- Analyzed **15 category × store combinations** to find drivers of volatility
- Delivered findings through a **2-page interactive dashboard** and executive deck

## 🔍 Key Findings

| # | Finding | Highlight |
|---|---|---|
| 1 | Revenue swung **2.3×** without clear seasonality | $20,680 → $47,522 |
| 2 | **Electronics** = most volatile category | Volatility 159.56% |
| 3 | **Beauty** = most stable category | StdDev $2,246 |
| 4 | **Bandung Store** = benchmark | 26.60% share, ATV $469.85 |
| 5 | **Jakarta** = weakest store | 42% revenue gap vs Bandung |
| 6 | Bandung's edge came from **Clothing & Beauty**, not Electronics | Top 2 combos |
| 7 | High discounts ≠ high revenue | 12–13% discount, lowest revenue |
| 8 | Cause of decline **shifted between categories** | March = Electronics, Jun–Sep = Clothing |

## 💡 Recommendations

| Priority | Action | Target |
|---|---|---|
| 1 | Audit Jakarta vs Bandung (traffic, mix, pricing, promo) | Close 42% gap |
| 2 | Monitor Electronics volatility | Reduce from 159.56% → <100% |
| 3 | Replicate Clothing & Beauty × Bandung playbook | Lift top-5 share to ≥45% |
| 4 | Validate discount effectiveness at product × store × period | Statistical test |
| 5 | Integrate cost & inventory data | Move revenue → profitability |

## 🛠 Tech Stack

`Python (Pandas)` · `PostgreSQL` · `SQL` · `Power BI` · `Jupyter Notebook`


## ⚠️ Limitations

This analysis measures **revenue, not profitability**. Dataset has no cost, COGS,
inventory, stockout, or promotion data — so several findings remain hypotheses
that require validation with additional data sources. Gender column was dropped
(5.3% missing). Scope is descriptive & diagnostic only (no forecasting).

## 👤 Author

**Andre Nugraha Akbar** — Data Analyst

---

> *Feedback welcome — feel free to open an issue or connect.*

