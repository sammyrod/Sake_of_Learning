CREATE OR ALTER FUNCTION fn_SplitStringToTable(
	@String VARCHAR(MAX),
	@Delimiter VARCHAR(25)=',',
	@IsNewLine INT=0 
)
RETURNS @Table TABLE (
	ResultId INT IDENTITY(1, 1),
	Result VARCHAR(MAX)
)
AS
/****************************************
* Author: Samuel Rodriguez
* Title: Data Science Analyst
* Description: Split any string or varchar by a delimiter
*	returns a table with the results
*****************************************/
BEGIN
	DECLARE @XML AS XML;
	BEGIN
	IF @IsNewLine = 1 SET @Delimiter=CHAR(13);
	END;

	SET @XML = N'<root><row>' + REPLACE(@String, @Delimiter, '</row><row>') + '</row></root>';

	--PRINT CONVERT(VARCHAR(MAX), @XML);

	INSERT INTO @Table(Result)
	SELECT Item.value('.', 'VARCHAR(MAX)') AS Value
	FROM @XML.nodes('//root/row') AS Items(Item);

	RETURN;
END
GO

SELECT * from fn_SplitStringToTable('
split, 
this, 
text, 
use, 
for, 
and, 
procedure, 
codes, 
or for many other things', default, default)

SELECT * from fn_SplitStringToTable('
split
this 
text 
use 
for 
and 
procedure 
codes
or for many other things', default, 1)
