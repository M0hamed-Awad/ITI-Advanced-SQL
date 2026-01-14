# 🏛️ Day 03 - Views, Indexing, and Data Synchronization

### 🎯 Objectives
* **Data Abstraction:** Create virtual tables (Views) to simplify complex multi-table joins and provide a simplified interface for end-users.
* **Security & Governance:** Implement **View Encryption** to protect source code from unauthorized viewing and **WITH CHECK OPTION** to enforce data integrity during DML operations through views.
* **Nested Logic:** Develop modular database designs by creating views that consume other views.
* **Performance Tuning:** Analyze the physical constraints of **Clustered vs. Non-Clustered Indexes** and their impact on data retrieval.
* **Data Integration:** Utilize the **MERGE** statement to synchronize tables using a single, atomic execution plan (UPSERT logic).

---

### 📄 Lab Modules

#### ⚙️ Module 1: View Programmability & Security
* **Abstraction:** Built views to consolidate Student, Course, and Department data into single-call objects.
* **Security:** Applied `WITH ENCRYPTION` to hide the underlying T-SQL logic from system metadata, preventing users from seeing the source query via `sp_helptext`.
* **Integrity:** Used `WITH CHECK OPTION` to ensure that any `INSERT` or `UPDATE` performed through a view stays within the defined filtering criteria (e.g., preventing a 'Cairo' view from being used to move a student to 'Tanta').



#### 🏗️ Module 2: Physical Storage & Indexing
* **Clustered Indexes:** Verified that only one clustered index can exist per table as it defines the physical sorting order of the data on the disk.
* **Non-Clustered Indexes:** Implemented secondary lookup structures to accelerate filtering on non-key columns such as `HireDate`.
* **Conflict Resolution:** Identified that Unique Indexes cannot be applied to columns already containing duplicate values, emphasizing the need for data cleaning before optimization.



#### 🔄 Module 3: Advanced Synchronization (The MERGE Statement)
* Implemented a full **MERGE** operation to synchronize a `Daily_Transactions` source with a `Last_Transactions` target.
* **Logic Breakdown:**
    * **MATCHED:** Updates existing records with new transaction amounts.
    * **NOT MATCHED BY TARGET:** Inserts new records that exist in the source but not the target.
    * **NOT MATCHED BY SOURCE:** Automatically cleans up (deletes) records in the target that are no longer present in the source.

---

### 💡 Technical Insights

* **View Dependencies:** Task 4 in Part 2 demonstrates **Nested Views**. While excellent for code reuse, deep nesting can hide complexity and should be monitored for performance impacts.
* **Indexing Trade-offs:** A Clustered Index is the table itself. Adding Non-Clustered indexes adds overhead to `INSERT/UPDATE` operations but significantly reduces `SELECT` time.
* **Atomic UPSERT:** The `MERGE` statement is preferred over individual `UPDATE` and `INSERT` blocks because it is more efficient and provides a cleaner syntax for data synchronization.