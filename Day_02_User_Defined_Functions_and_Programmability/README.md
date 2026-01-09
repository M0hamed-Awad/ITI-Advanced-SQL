# ⚙️ Day 02 - User-Defined Functions & T-SQL Logic

### 🎯 Objectives
* Implement **Scalar Functions** for single-value transformations.
* Master **Table-Valued Functions (TVFs)**:
    * **Inline TVFs:** Optimized for performance (treated like Views).
    * **Multi-Statement TVFs:** For complex logic involving loops and multiple steps.
* Explore **Control of Flow** using `WHILE` loops and `CASE` statements.
* Understand **String Manipulation** functions (`SUBSTRING`, `LEN`, `FORMAT`).
* Introduction to **Specialized Data Types**: Using `hierarchyid` for tree-structured data.
* Perform **Bulk Data Generation** using T-SQL batches.

---

### 📝 Lab Modules (Contained in `Lab-2.sql`)

#### 1. Function Development
* **Date Handling:** A scalar function to extract month names using `FORMAT`.
* **Range Generation:** A multi-statement function that populates a table variable using a `WHILE` loop.
* **Student & Dept Logic:** Inline functions to simplify complex joins between `Student`, `Instructor`, and `Department`.
* **Conditional Messages:** Using `CASE` inside a function to handle various `NULL` scenarios for user names.

#### 2. Advanced T-SQL Scripting
* **String Processing:** Logic to trim characters dynamically using `LEN` and `SUBSTRING`.
* **Bulk Insertion:** A batch script that uses a loop to generate 3000 unique records for testing purposes.
* **HierarchyID:** Demonstration of the `hierarchyid` type to represent organizational levels (Root and Descendants).