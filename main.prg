/**
 @AUTHOR John Murowaniecki (jmurowaniecki@gmail.com)
 @ABSTRACT Catalog of Magic the Gathering cards.
*/
	// Definition block for screen saving and restoring
	#DEFINE DOS_SCR	1
	#DEFINE DOS_ROW	2
	#DEFINE DOS_COL	3
	#DEFINE DOS_CUR	4
	#DEFINE DOS_MXR	5
	#DEFINE DOS_MXC	6
	#DEFINE DOS_CLR 7
	#DEFINE DOS_CNT	7
	//

PROCEDURE _PRC_CONFIG()
	// A simple pack of rules
	SET MESSAGE TO MaxRow() - 1 CENTRE
	SET DATE FORMAT TO "dd/mm/yyyy"
	SET DELIMITERS TO "[]"
	SET ALTERNATE TO LOG_FILE
	SET DECIMALS TO 2
	SET EPOCH TO 1960
	//

	// Another pack of rules
	SET DELIMITERS	OFF
	SET SCOREBOARD	OFF
	SET ALTERNATE	OFF
	SET SOFTSEEK	OFF
	SET CONFIRM	ON
	SET CONSOLE	ON
	SET ESCAPE	ON
	SET CURSOR	ON
	SET BELL	OFF
	SET WRAP	OFF
	//

	RETURN
//

// Boot function - save screen stats
INIT PROCEDURE _DOS_Construct()
PUBLIC IBM_rStats := ARRAY(DOS_CNT)
	IBM_rStats[ DOS_SCR ] := SaveScreen( 0, 0, MaxRow(), MaxCol())
	IBM_rStats[ DOS_ROW ] := Row()
	IBM_rStats[ DOS_COL ] := Col()
	IBM_rStats[ DOS_CUR ] := SetCursor()
	IBM_rStats[ DOS_MXR ] := MaxRow()
	IBM_rStats[ DOS_MXC ] := MaxCol()
	IBM_rStats[ DOS_CLR ] := SetColor()
	_PRC_CONFIG()
	_PRC_MAIN()
	RETURN
//

/*/ Exit function - restore screen stats
EXIT PROCEDURE _DOS_destruct()
	RestScreen( 0, 0,;
		IBM_rStats[ DOS_MXR ],;
		IBM_rStats[ DOS_MXC ],;
		IBM_rStats[ DOS_SCR ])
	DevPos(IBM_rStats[ DOS_MXR ], IBM_rStats[ DOS_MXC ])
	SetColor(IBM_rStats[ DOS_CLR ])
	SetCursor(IBM_rStats[ DOS_CUR ])
	RETURN
//*/

PROCEDURE _PRC_MAIN()
LOCAL aDBF_Struct := {{"tEDITION.DBF",;
					{	{"ID"		, 'N', 13, 0},;
						{"NAME"		, 'C', 32, 0}}},;
					{"tCOLORS.DBF",;
					{	{"ID"		, 'N', 13, 0},;
						{"NAME"		, 'C', 32, 0}}},;
					{"tTYPES.DBF",;
					{	{"ID"		, 'N', 13, 0},;
						{"NAME"		, 'C', 32, 0}}},;
					{"tRARITY.DBF",;
					{	{"ID"		, 'N', 13, 0},;
						{"NAME"		, 'C', 32, 0}}},;
					{"tCARDS.DBF",;
					{	{"ID"		, 'N', 13, 0},;
						{"EDITION"	, 'N', 13, 0},;
						{"COLOR"	, 'N', 13, 0},;
						{"TYPE"		, 'N', 13, 0},;
						{"RARITY"	, 'N', 13, 0},;
						{"YEAR"		, 'N', 13, 0},;
						{"NAME"		, 'C', 32, 0},;
						{"PRICE"	, 'N', 13, 2},;
						{"QUANTITY"	, 'N', 13, 0},;
						{"OBS"		, 'C', 64, 0}}}}
	//

	// This will be our visual scheme (:
	SET COLOR TO "w/n, w+/b, b+/n, n+/n"
	ColorSelect(0)
	CLEAR SCREEN
	//

	// This will be the structure of our database
	? _UTF8("Checking existance of database files..")
	FOR nCount := 1 TO LEN(aDBF_Struct)
		? _UTF8("..File " + aDBF_Struct[nCount][1] + ".. ")
		DO WHILE ! File(aDBF_Struct[nCount][1])
			?? _UTF8("Inexistant. Creating new.. ")
			DBCreate(aDBF_Struct[nCount][1], aDBF_Struct[nCount][2])
		ENDDO
		?? "Ok."
	NEXT nCount
	RETURN





// Some useful functions ahead
//
FUNCTION _UTF8(cString)
LOCAL aSearch := {"á", "é", "ó", "ú", "ã", "õ", "Ã", "Õ", "â", "ê", "ô", "ç", "Ç"},;
	aTransfrm := {160, 130, 162, 163, 132, 148, 142, 153, 131, 136, 147, 128, 128}
	IF VALTYPE(cString) != "C"
		RETURN cString
	ENDIF
	FOR n := 1 TO LEN(aSearch)
		cString := STRTRAN(cString, aSearch[n], CHR(aTransfrm[n]))
	NEXT
	RETURN cString
//

PROCEDURE _PrintAt(nX, nY, aTx, aCor)
LOCAL aFields
	IF VALTYPE(aTx) != "A"
		AADD(aFields, aTx)
		aTx := aFields
	ENDIF
	DevPos(nX, nY)
	FOR nCount := 1 TO LEN(aTx)
		cCor := IF(VALTYPE(aCor) = "A" .AND. LEN(aCor) >= nCount, aCor[nCount], aCor)
		ColorSelect(cCor)
		DevOut(aTx[nCount])
	NEXT
	ColorSelect(0)
	RETURN
//
