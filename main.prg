/**
 @AUTHOR John Murowaniecki (jmurowaniecki@gmail.com)
 @ABSTRACT Sistema de catalogo para cards colecionaveis de Magic the Gathering.
*/
// Bloco de definicoes para o sistema de inicialização e finalizacao.
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
// Conjunto de regras de configuracao do ambiente[1]
	SET MESSAGE TO MaxRow()-1 CENTRE
	SET DATE FORMAT TO "dd/mm/yyyy"
	SET DELIMITERS TO "[]"
	SET ALTERNATE TO LOG_FILE
	SET DECIMALS TO 2
	SET EPOCH TO 1960
//

// Conjunto de regras de configuracao do ambiente[2]
	SET DELIMITERS	OFF
	SET SCOREBOARD	OFF
	SET ALTERNATE	OFF
	SET SOFTSEEK	OFF
	SET CONFIRM	ON
	SET CONSOLE	OFF
	SET ESCAPE	ON
	SET CURSOR	ON
	SET BELL	OFF
	SET WRAP	OFF
//
	RETURN
//

// Funcao de inicializacao - captura tela e informacoes do ambiente
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

// Funcao de finalizacao - restaura tela e informacoes do ambiente
EXIT PROCEDURE _DOS_destruct()
	RestScreen( 0, 0,;
		IBM_rStats[ DOS_MXR ],;
		IBM_rStats[ DOS_MXC ],;
		IBM_rStats[ DOS_SCR ])
	DevPos(IBM_rStats[ DOS_MXR ], IBM_rStats[ DOS_MXC ])
	SetColor(IBM_rStats[ DOS_CLR ])
	SetCursor(IBM_rStats[ DOS_CUR ])
	RETURN
//

PROCEDURE _PRC_MAIN()
	RETURN