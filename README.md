# 🎤 Music Contest Database - SQL Server Project

A comprehensive SQL Server database project for managing music competitions, including contestants, performances, judges, ratings, and eliminations. This project demonstrates advanced SQL Server features including stored procedures, triggers, functions, transactions, and more.

## 📚 Project Overview

This database system manages all aspects of music competitions similar to shows like "The Voice Israel", "A Star is Born", and other singing competitions. The project showcases practical implementation of advanced SQL Server concepts and database design principles.

### Key Features
- **Complete Competition Management** - Track competitions from start to finish
- **Contestant Tracking** - Manage contestant information and types
- **Performance Recording** - Record all performances with songs and dates
- **Rating System** - Multi-judge rating system with validation
- **Elimination Tracking** - Track eliminations with reasons
- **Advanced SQL Features** - Stored procedures, triggers, functions, views, and more

## 🗄️ Database Schema

### Entity Relationship Diagram

```
Contestants ──┐
              ├──> Performances ──┐
Competitions ─┘                   ├──> Ratings
                                  │
Contestants_Type ─────────────────┴──> (Rating validation)

Contestants ──┐
              ├──> Eliminations
Competitions ─┤
              └──> Elimination_Reasons
```

### Tables

#### 1. **Contestants** (משתתפים)
Stores information about competition participants.

| Column | Type | Description |
|--------|------|-------------|
| ContestantID | INT (PK, IDENTITY) | Unique contestant identifier |
| Tz | NVARCHAR(9) | Israeli ID number |
| First_Name | NVARCHAR(50) | First name |
| Last_Name | NVARCHAR(50) | Last name |
| Age | INT | Age |
| Contestants_Type | INT (FK) | Type of contestant (competitor/judge/audience) |

**Data**: 15 contestants with Israeli names

#### 2. **Contestants_Type** (סוג משתתף)
Defines types of participants.

| Column | Type | Description |
|--------|------|-------------|
| Contestants_Type_ID | INT (PK, IDENTITY) | Type ID |
| Contestants_Type_Name | NVARCHAR(50) | Type name |

**Types**:
- מתחרה (Competitor)
- שופט (Judge)
- קהל (Audience)

#### 3. **Competitions** (תחרויות)
Competition information and dates.

| Column | Type | Description |
|--------|------|-------------|
| CompetitionID | INT (PK, IDENTITY) | Competition ID |
| Name_Competitions | NVARCHAR(100) | Competition name |
| Start_Date | DATE | Start date |
| End_Date | DATE | End date |

**Sample Competitions**:
- הכוכב הבא 2015 (The Next Star 2015)
- קול ישראל 2016 (Voice of Israel 2016)
- The Voice ישראל 2019
- And 8 more competitions spanning 2015-2025

#### 4. **Performances** (ביצועים)
Individual performance records.

| Column | Type | Description |
|--------|------|-------------|
| PerformanceID | INT (PK, IDENTITY) | Performance ID |
| ContestantID | INT (FK) | Contestant performing |
| SongName | NVARCHAR(100) | Song name (Hebrew) |
| PerformanceDate | DATE | Performance date |
| CompetitionID | INT (FK) | Associated competition |

**Data**: 23 performances with Hebrew song names

#### 5. **Ratings** (דירוגים)
Judge ratings for performances.

| Column | Type | Description |
|--------|------|-------------|
| RatingID | INT (PK, IDENTITY) | Rating ID |
| PerformanceID | INT (FK) | Performance being rated |
| Ratings_Type | INT (FK) | Type of rater |
| Score | FLOAT | Score (1-10) |

**Validation**: Trigger ensures scores are between 1-10 and only valid rating types

#### 6. **Eliminations** (הדחות)
Tracks contestant eliminations.

| Column | Type | Description |
|--------|------|-------------|
| EliminationID | INT (PK, IDENTITY) | Elimination ID |
| ContestantID | INT (FK) | Eliminated contestant |
| CompetitionID | INT (FK) | Competition |
| EliminationRound | INT | Round number |
| EliminationReason | INT (FK) | Reason for elimination |

#### 7. **Elimination_Reasons** (סיבת הדחה)
Predefined elimination reasons.

| Column | Type | Description |
|--------|------|-------------|
| ReasonID | INT (PK, IDENTITY) | Reason ID |
| Reason_Description | NVARCHAR(225) | Description |

**Reasons**:
- קיבל את מספר ההצבעות הנמוך ביותר (Received lowest votes)
- פרש מרצונו (Withdrew voluntarily)
- עבירה על הכללים (Rules violation)
- אחר (Other)

## 🔧 Advanced SQL Features

### 1. Stored Procedures (פורצדורות)

#### Primary Procedure: `Insert_Rating_And_Get_Top3`
```sql
EXEC Insert_Rating_And_Get_Top3 
    @PerformanceID = 5,
    @Ratings_Type = 2,
    @Score = 10
```

**Functionality**:
- Inserts a new rating
- Returns TOP 3 performers based on average score
- Shows ranking of the specific performance
- Uses CTE (Common Table Expressions) with window functions

**Key Techniques**:
- `DENSE_RANK()` for ranking
- `AVG()` aggregation
- Multiple JOINs
- Grouped queries

#### Nested Procedures
The project includes procedures calling other procedures, demonstrating:
- Modular code design
- Reusable components
- Complex workflows

### 2. Triggers (טריגרים)

#### Validation Trigger: `trg_takin`
```sql
CREATE TRIGGER trg_takin
ON Ratings
AFTER INSERT, UPDATE
```

**Validations**:
1. **Score Range**: Ensures scores are between 1-10
2. **Rating Type**: Only allows types 2 or 3 (judges and audience)
3. **Performance Existence**: Validates performance exists before rating

**Error Handling**:
- Accumulates multiple error messages
- Uses `ROLLBACK TRANSACTION` on validation failure
- Provides clear Hebrew error messages

### 3. Functions (פונקציות)

#### Scalar Function: `Get_Performance_Count`
```sql
SELECT dbo.Get_Performance_Count(1, 1)
-- Returns: Number of performances by contestant 1 in competition 1
```

**Purpose**: Count performances for a specific contestant in a specific competition

**Features**:
- Returns `INT`
- Uses `ISNULL()` for safe return
- Can be used in SELECT statements

#### Usage Example
```sql
-- Get performance counts for all contestants in competition 1
SELECT 
    c.First_Name,
    c.Last_Name,
    dbo.Get_Performance_Count(c.ContestantID, 1) AS PerformanceCount
FROM Contestants c
```

### 4. Views (ויו)

#### Comprehensive View: `vw_Contestants_Details`
```sql
SELECT * FROM vw_Contestants_Details
```

**Data Included**:
- Contestant information (ID, name, age, type)
- Song names and performance dates
- Average scores
- Competition names
- Elimination reasons (if eliminated)

**Join Strategy**:
- Multiple `LEFT JOIN` operations
- Aggregated data with `GROUP BY`
- Complete contestant profile in one view

### 5. Transactions (טרנזקציות)

#### Transaction with Error Handling
```sql
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE Ratings
    SET Score = 8.5
    WHERE RatingID = 10 AND Score BETWEEN 0 AND 10;
    
    COMMIT TRANSACTION;
    PRINT 'העדכון בוצע בהצלחה!';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'שגיאה התרחשה! העדכון בוטל.';
END CATCH
```

**Features**:
- Atomicity guarantee
- Automatic rollback on error
- Hebrew success/error messages

### 6. Control Flow (לולאות)

#### WHILE Loop Example
```sql
-- Iterate through all performances and print average scores
```

**Purpose**: Loop through all performances and display contestant names with average scores

**Techniques**:
- `WHILE` loop with cursor-like behavior
- Multiple variable declarations
- String concatenation
- Sequential processing

### 7. Advanced Queries

#### UNION
Combines result sets from multiple queries

#### CROSS APPLY
Advanced joining technique for table-valued functions

#### Dynamic SQL
Execute dynamically generated SQL statements

## 📦 Installation & Setup

### Prerequisites
- SQL Server 2016 or higher
- SQL Server Management Studio (SSMS)
- Basic understanding of T-SQL

### Installation Steps

#### Step 1: Create Database
```sql
-- Run: יצירת DB.sql
-- This will:
-- 1. Create the database
-- 2. Create all tables
-- 3. Set up foreign key relationships
-- 4. Insert sample data
```

#### Step 2: Create Advanced Features

Execute scripts in this order:
1. **פונקציה.sql** - Create functions
2. **ויו.sql** - Create views
3. **פורצדורה.sql** - Create stored procedures
4. **טריגר.sql** - Create triggers

#### Step 3: Test Features

```sql
-- Test stored procedure
EXEC Insert_Rating_And_Get_Top3 
    @PerformanceID = 5,
    @Ratings_Type = 2,
    @Score = 9

-- Test function
SELECT dbo.Get_Performance_Count(1, 1)

-- Test view
SELECT * FROM vw_Contestants_Details

-- Test transaction
-- Run: טרנזקציה.sql

-- Test while loop
-- Run: While.sql
```

## 🎯 Sample Queries

### Basic Queries

#### Get All Contestants with Their Types
```sql
SELECT 
    c.First_Name,
    c.Last_Name,
    ct.Contestants_Type_Name,
    c.Age
FROM Contestants c
JOIN Contestants_Type ct ON c.Contestants_Type = ct.Contestants_Type_ID
ORDER BY c.Last_Name
```

#### Competition Rankings
```sql
SELECT 
    c.First_Name + ' ' + c.Last_Name AS Contestant,
    com.Name_Competitions,
    AVG(r.Score) AS AvgScore,
    RANK() OVER (PARTITION BY p.CompetitionID ORDER BY AVG(r.Score) DESC) AS Rank
FROM Ratings r
JOIN Performances p ON r.PerformanceID = p.PerformanceID
JOIN Contestants c ON p.ContestantID = c.ContestantID
JOIN Competitions com ON p.CompetitionID = com.CompetitionID
GROUP BY c.First_Name, c.Last_Name, com.Name_Competitions, p.CompetitionID
ORDER BY com.Name_Competitions, Rank
```

#### Find Eliminated Contestants
```sql
SELECT 
    c.First_Name + ' ' + c.Last_Name AS Contestant,
    com.Name_Competitions,
    e.EliminationRound AS Round,
    er.Reason_Description
FROM Eliminations e
JOIN Contestants c ON e.ContestantID = c.ContestantID
JOIN Competitions com ON e.CompetitionID = com.CompetitionID
JOIN Elimination_Reasons er ON e.EliminationReason = er.ReasonID
ORDER BY com.CompetitionID, e.EliminationRound
```

### Advanced Queries

#### Top Performers Across All Competitions
```sql
WITH PerformerStats AS (
    SELECT 
        c.ContestantID,
        c.First_Name + ' ' + c.Last_Name AS Name,
        COUNT(DISTINCT p.CompetitionID) AS CompetitionsParticipated,
        COUNT(p.PerformanceID) AS TotalPerformances,
        AVG(r.Score) AS OverallAvgScore,
        MAX(r.Score) AS BestScore
    FROM Contestants c
    JOIN Performances p ON c.ContestantID = p.ContestantID
    JOIN Ratings r ON p.PerformanceID = r.PerformanceID
    GROUP BY c.ContestantID, c.First_Name, c.Last_Name
)
SELECT 
    Name,
    CompetitionsParticipated,
    TotalPerformances,
    ROUND(OverallAvgScore, 2) AS AvgScore,
    BestScore
FROM PerformerStats
WHERE OverallAvgScore >= 7
ORDER BY OverallAvgScore DESC
```

#### Competition Analysis
```sql
SELECT 
    com.Name_Competitions,
    COUNT(DISTINCT p.ContestantID) AS TotalContestants,
    COUNT(p.PerformanceID) AS TotalPerformances,
    AVG(r.Score) AS AvgScore,
    MAX(r.Score) AS HighestScore,
    MIN(r.Score) AS LowestScore
FROM Competitions com
JOIN Performances p ON com.CompetitionID = p.CompetitionID
JOIN Ratings r ON p.PerformanceID = r.PerformanceID
GROUP BY com.Name_Competitions, com.CompetitionID
ORDER BY com.Start_Date DESC
```

## 🛠️ Technologies Used

- **SQL Server** - Relational database management system
- **T-SQL** - Transact-SQL for advanced features
- **SSMS** - SQL Server Management Studio

## 📊 Data Statistics

### Database Contents
- **Competitions**: 11 competitions (2015-2025)
- **Contestants**: 15 participants
- **Performances**: 23 performances
- **Ratings**: 79 ratings
- **Eliminations**: 13 eliminations
- **Contestant Types**: 3 types
- **Elimination Reasons**: 4 reasons

### Data Characteristics
- Hebrew language support (NVARCHAR)
- Date ranges spanning 10 years
- Score range: 1-10 (float)
- Multiple competitions per contestant
- Multiple ratings per performance

## 🎓 Learning Outcomes

This project demonstrates proficiency in:

### Database Design
- ✅ Normalized database structure (3NF)
- ✅ Proper primary and foreign key relationships
- ✅ Appropriate data types for Hebrew text
- ✅ Referential integrity

### T-SQL Programming
- ✅ Stored procedures with parameters
- ✅ User-defined functions
- ✅ Triggers with validation logic
- ✅ Transactions with error handling
- ✅ Views for data abstraction

### Advanced SQL Concepts
- ✅ Window functions (RANK, DENSE_RANK, ROW_NUMBER)
- ✅ Common Table Expressions (CTEs)
- ✅ Complex JOINs (INNER, LEFT, multiple tables)
- ✅ Aggregations with GROUP BY
- ✅ Subqueries and derived tables
- ✅ Control flow (WHILE loops, IF statements)
- ✅ Dynamic SQL execution

### Best Practices
- ✅ Proper error handling with TRY-CATCH
- ✅ Transaction management
- ✅ Data validation with triggers
- ✅ Code modularity with procedures
- ✅ Reusable functions
- ✅ Clear naming conventions

## 🔐 Data Integrity Features

### Constraints
- Primary keys on all tables (IDENTITY)
- Foreign key relationships with CASCADE options
- NOT NULL constraints on required fields
- Proper data type usage

### Validation
- Trigger-based score validation (1-10)
- Rating type validation
- Performance existence checks
- Transaction-based updates

### Error Handling
- Comprehensive TRY-CATCH blocks
- Meaningful error messages in Hebrew
- Automatic rollback on errors
- Validation before data modification

## 🚀 Usage Examples

### Adding a New Rating
```sql
-- Using the stored procedure
EXEC Insert_Rating_And_Get_Top3 
    @PerformanceID = 15,
    @Ratings_Type = 2,
    @Score = 9.5
    
-- Results:
-- 1. Inserts the rating
-- 2. Shows TOP 3 performers
-- 3. Shows ranking of performance #15
```

### Checking Performance Count
```sql
-- How many times did contestant 1 perform in competition 1?
SELECT dbo.Get_Performance_Count(1, 1) AS PerformanceCount
```

### Viewing Complete Contestant Data
```sql
-- Get all information about a contestant
SELECT * 
FROM vw_Contestants_Details
WHERE First_Name = N'נועם' AND Last_Name = N'כהן'
```

## 📝 Project Structure

```
sql_project/
├── יצירת DB.sql                    # Main database creation script
├── פורצדורה.sql                    # Stored procedures
├── פורצדורה בתוך פורצדורה.sql      # Nested procedures
├── פורצדורה שמשתמשת בפונקציה.sql   # Procedure using function
├── פונקציה.sql                     # User-defined functions
├── טריגר.sql                       # Triggers
├── ויו.sql                         # Views
├── טרנזקציה.sql                    # Transactions
├── While.sql                       # While loops
├── Try catch.sql                   # Error handling examples
├── Union.sql                       # UNION examples
├── CROSS APPLY.sql                 # CROSS APPLY examples
├── sql dynamic.sql                 # Dynamic SQL
├── סלקט מתוך טבלה שמשתמשת בפונקציה.sql  # SELECT with function
└── DB.docx                         # Documentation (Word)
```

## 🔄 Future Enhancements

Potential improvements:
- [ ] Add authentication and security roles
- [ ] Implement stored procedure for automatic ranking calculation
- [ ] Create scheduled jobs for competition status updates
- [ ] Add indexes for performance optimization
- [ ] Implement full-text search on song names
- [ ] Create backup and restore procedures
- [ ] Add audit trail for data changes
- [ ] Implement cascading updates/deletes
- [ ] Create dashboard views for management
- [ ] Add performance statistics functions
- [ ] Implement voting system for audience
- [ ] Create reports with SSRS

## 🐛 Troubleshooting

### Common Issues

#### Permission Errors
```sql
-- Grant necessary permissions
USE MusicContestDB
GO
GRANT EXECUTE ON dbo.Insert_Rating_And_Get_Top3 TO [YourUser]
GO
```

#### Trigger Validation Failures
If ratings fail validation:
- Check score is between 1-10
- Verify Ratings_Type is 2 or 3
- Ensure PerformanceID exists

#### Foreign Key Violations
- Always insert parent records before child records
- Check referential integrity
- Verify IDs exist in parent tables

## 📚 Additional Resources

- [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/sql-server/)
- [T-SQL Reference](https://docs.microsoft.com/en-us/sql/t-sql/language-reference)
- [Stored Procedures Best Practices](https://docs.microsoft.com/en-us/sql/relational-databases/stored-procedures/)
- [Trigger Design Guidelines](https://docs.microsoft.com/en-us/sql/relational-databases/triggers/)

## 📄 License

This project is created for educational purposes as part of SQL Server database learning.

## 👥 Contributing

This is a learning project showcasing SQL Server capabilities. Feedback and suggestions are welcome!

## 📧 Contact

For questions or feedback about this project:
- GitHub: [ayala-2005](https://github.com/ayala-2005)

---

**Note**: This project demonstrates comprehensive SQL Server knowledge including database design, T-SQL programming, stored procedures, triggers, functions, transactions, and advanced querying techniques. All data is fictional and created for educational purposes. The Hebrew text demonstrates proper handling of Unicode data in SQL Server.

🎤 **Music Contest Database** - A complete SQL Server project showcasing advanced database programming and design patterns.
