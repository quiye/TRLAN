SUBROUTINE RESL_MAIN(start_row,which,MODE,ACCURACY,N,K,M,IAP,JA,A,WORK,LWORK)
  use omp_lib
  IMPLICIT NONE

  CHARACTER MODE
  INTEGER start_row(*),II,Z,JJ
  DOUBLE PRECISION A(*),WORK(*),TM(M,M),VM(N,M),VPLUS(N),INIT_VEC(N),PQ,PP
  DOUBLE PRECISION MIN_ERR,TMP_ERR,TE0,STARTT,TMPT,MINT,CONST,ZERO,MINUSONE,TEN,ERR,DNRM2
  PARAMETER (ZERO = 0.0D+0,MINUSONE = -1.0D+0,TEN = 10.0D+0)
  INTEGER ISEED(4), IAP(*), JA(*),which
  INTEGER N,K,M,INFO,COU,SELEK,ACCURACY,I,W,ITR,LWORK

  ISEED( 1 ) = 132
  ISEED( 2 ) = 314
  ISEED( 3 ) = 13333
  ISEED( 4 ) = 733
  print *, "MODE = ",MODE
  WRITE (*,*) "N M K"
  WRITE (*,*) N,M,K

  CONST = TEN**(ZERO - accuracy)
  if(N<M) then
     print *,"! ERR K must be smaller than",min(N,N)/2
  end if

  CALL DLARNV(1,ISEED,N,INIT_VEC)
  INIT_VEC = INIT_VEC / DNRM2(N,INIT_VEC,1)
  DO SELEK = 2, 2!, 2
     STARTT = omp_get_wtime()
     WRITE(*,*) 
     TM = ZERO
     VM = ZERO
     MIN_ERR = MINUSONE
     COU = 0
     ITR = 0
     I = 1
     VPLUS = INIT_VEC
     ! ヒゲの部分の最大の絶対値がリスタートルーチンを呼び出しても更新されないのが100回続いたら停止
     DO WHILE (COU < 10000)
        CALL RESL(start_row,which,I,mode,IAP,JA,A,N,M,K,TM,VM,VPLUS,INFO,SELEK,WORK,LWORK)
        TMP_ERR = MAXVAL(ABS(TM(1:K,K+1)))!ヒゲの最大絶対値

        ITR = ITR+1
        TMPT = omp_get_wtime()
        IF ( (TMP_ERR < MIN_ERR) .OR. (MIN_ERR .EQ. MINUSONE) ) THEN
           MIN_ERR = TMP_ERR
           MINT = TMPT
           COU = -1!更新されたら初期化
        END IF

        WRITE(*,*) SELEK,ITR,(TMPT-STARTT),TMP_ERR
        IF(TMP_ERR .LE. CONST) exit!十分小さくなったら抜ける
        COU = COU + 1
     END DO

     TE0 = ERR(start_row,mode,IAP,JA,A,N,M,K,TM,VM,WORK)
     WRITE(*,*) "TIME", SELEK,ITR,(TMPT-STARTT),TMP_ERR,"SUM",TE0
         DO II = 2, k
            I = II - 1
            Z = I
            PP= TM(I,I)
            DO JJ = II, k
               IF( TM(JJ,JJ).LT.PP) THEN
                  Z = JJ
                  PP= TM(JJ,JJ)
               END IF
            END DO
            IF( Z.NE.I ) THEN
               PQ=TM(Z,Z)
               TM(Z,Z) = TM(I,I)
               TM(I,I) = PQ
            END IF
         END DO
     DO I = 1,k
        WRITE (*,*) "EigenValue(1-3)",I, TM(I,I)
     END DO
  END DO

END SUBROUTINE RESL_MAIN
