C
C*************************  ABSTRACT  ***********************************
C
C   THIS PROGRAM USES THE EXPLICIT EULER METHOD TO INTEGRATE A SYSTEM OF
C  FIRST ORDER ODE'S.  THE USER SUPPLIES THE INITIAL CONDITIONS AND THE
C  FINAL VALUE OF X, AS WELL AS THE EQUATIONS FOR F(X,Y).
C
C****************************  NOMENCLATURE  **************************
C
C  DX-  THE STEP SIZE
C  DXPNT- THE PRINT INTERVAL
C  DYDX(I)- THE DERIVATIVE OF Y(I) WITH RESPECT TO X
C  FUNCT- THE NAME OF THE SUBROUTINE THAT CALCULATES F(X,Y)
C  IPNT- PRINT FLAG (=0 NO PRINT; =1 PRINT)
C  N- THE NUMBER OF DEPENDENT VARIABLES
C  X-  THE INDEPENDENT VARIABLE
C  XMAX-  THE FINAL VALUE OF X
C  Y(I)-  THE ITH DEPENDENT VARIABLE
C
C**********************************************************************
C
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION Y(2),DYDX(2)
C  EXTERNAL STATEMENT OF DERIVATIVE SUBROUTINE
      EXTERNAL FUNCT
C  SPECIFY INPUT DATA
      N=2
      X=0.0
      Y(1)=1.
      Y(2)=300.
      XMAX=100.
      DX=.02
      IPNT=1
      DXPNT=10.
C  CALL EULER METHOD
      CALL EULER(FUNCT,N,DX,X,Y,XMAX,IPNT,DXPNT,DYDX)
      STOP
      END
C
C*****************************  ABSTRACT  *****************************
C
C     THIS SUBROUTINE CALLS SUBROUTINE E1 AT EACH PRINT INTERVAL
C  AND PRINTS OUT THE INTERMEDIATE RESULTS IF IPNT=1.
C
C****************************  NOMENCLATURE  **************************
C
C  DX-  THE STEP SIZE
C  DXPNT- THE PRINT INTERVAL
C  DXP- THE INTERNALLY CALCULATED PRINT INTERVAL
C  DYDX(I)- THE DERIVATIVE OF Y(I) WITH RESPECT TO X
C  F- THE NAME OF THE SUBROUTINE THAT CALCULATES F(X,Y)
C  IPNT- PRINT FLAG (=0 NO PRINT; =1 PRINT)
C  N- THE NUMBER OF DEPENDENT VARIABLES
C  NS- THE NUMBER OF PRINT INTERVAL STEPS
C  PRO- THE PRINT INTERVAL NEAR XMAX
C  X- THE INDEPENDENT VARIABLE
C  XF- THE VALUE OF X AT THE END OF THE PRINT INTERVAL
C  XO- THE VALUE OF X AT THE BEGINNING OF THE PRINT INTERVAL
C  XMAX-  THE FINAL VALUE OF X
C  Y(I)-  THE ITH DEPENDENT VARIABLE
C
C**********************************************************************
C
      SUBROUTINE EULER(F,N,DX,X,Y,XMAX,IPNT,DXPNT,DYDX)
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION Y(1),DYDX(1)
      EXTERNAL F
C  CHECK DXPNT
      IF(DX.GT.DXPNT)WRITE(6,88)
   88 FORMAT( ' DX HAS BEEN SPECIFIED TO BE MORE THAN DXPNT')
      IF(DX.GT.DXPNT)STOP
C  PRINT INITIAL CONDITIONS IF IPNT = 1
      IF(IPNT.EQ.1)WRITE(6,10)X,(Y(J),J=1,N)
C  CALCULATE THE NUMBER OF STEPS PER DXPNT
      DXP=DXPNT
      NS=IFIX(XMAX/DXPNT)+1
      XO=X
      PRO=XMAX-DXPNT*DFLOAT(NS-1)
C
C  CALL SUBROUTINE E1 TIL X=XMAX
C
      DO 1000 I=1,NS
      IF(I.EQ.NS)DXP=PRO
      IF((I.EQ.NS).AND.(PRO.LT.1.E-6))GO TO 1000
      XF=XO+DXP
C  CALL SUBROUTINE E1
      CALL E(F,N,DX,XO,XF,Y,DYDX)
C  PRINT INTERMEDIATE RESULTS IF IPNT=1
      IF(IPNT.EQ.1)WRITE(6,10)XF,(Y(J),J=1,N)
   10 FORMAT( 10X,3H X=,D12.5,3X,3H Y=,4(D14.7,3X))
C  INCREMENT X
 1000 XO=XO+DXP
      RETURN
      END
C
C*****************************  ABSTRACT  *****************************
C
C     THIS SUBROUTINE APPLIES THE EULER METHOD FOR THE INTEGRATION OF
C  A SYSTEM OF FIRST ORDER ODE'S FROM X=XO TO X=XF.
C
C****************************  NOMENCLATURE  *************************
C
C  DX-  THE STEP SIZE
C  DXX- INTERNALLY USED STEP SIZE
C  DYDX(I)- THE DERIVATIVE OF Y(I) WITH RESPECT TO X
C  F- THE NAME OF THE SUBROUTINE THAT CALCULATES F(X,Y)
C  N- THE NUMBER OF DEPENDENT VARIABLES
C  NS- THE NUMBER OF DX INTERVAL STEPS
C  PRO- THE VALUE OF DX NEAR XF
C  X- THE INDEPENDENT VARIABLE
C  XF- THE VALUE OF X AT THE END OF THE PRINT INTERVAL
C  XO- THE VALUE OF X AT THE BEGINNING OF THE PRINT INTERVAL
C  XMAX-  THE FINAL VALUE OF X
C  Y(I)-  THE ITH DEPENDENT VARIABLE
C
C************************************************************************
C
C
      SUBROUTINE E(F,N,DX,XO,XF,Y,DYDX)
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION Y(1),DYDX(1)
      EXTERNAL F
      X=XO
C  CALCULATE THE NUMBER OF STEPS TO REACH XF
      XD=XF-XO
      NS=IFIX(XD/DX)+1
      DXX=DX
      PRO=XD-DX*DFLOAT(NS-1)
C
C  APPLY EULER APPROXIMATION FROM X=XO TO X=XF
C
      DO 100 I=1,NS
C  CALCULATE DX FOR END OF PRINT INTERVAL
      IF(I.EQ.NS)DXX=PRO
C  CALCULATE DYDX(I)
      CALL F(N,X,Y,DYDX)
      IF(XF-X.LT.DXX)DXX=XF-X
      X=X+DXX
C  APPLY EULER APPROXIMATION
      DO 10 K=1,N
   10 Y(K)=Y(K)+DXX*DYDX(K)
  100 CONTINUE
      RETURN
      END
C
C*****************************  ABSTRACT  *****************************
C
C     THIS SUBROUTINE CALCULATES THE DERIVATIVE OF Y WITH RESPECT TO X,
C  DYDX.  THIS EQUATION IS USER SUPPLIED.
C
C**********************************************************************
      SUBROUTINE FUNCT(N,X,Y,DYDX)
      DOUBLE PRECISION X,Y(2),DYDX(2)
      DYDX(1)=-.1*Y(1)*DEXP(-300./Y(2))
      DYDX(2)=1.*Y(1)*DEXP(-300./Y(2))
      RETURN
      END