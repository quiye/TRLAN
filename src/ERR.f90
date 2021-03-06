DOUBLE PRECISION FUNCTION ERR(start_row,mode,IAP,JA,A,N,K,L,BK,VK,VTEMP)
  IMPLICIT NONE
  CHARACTER MODE
  INTEGER N,K,L,I
  INTEGER start_row(*)
  INTEGER IAP(*),JA(*)
  DOUBLE PRECISION ONE,ZERO,DNRM2
  PARAMETER(ONE = 1.0D+0,ZERO = 0.0D+0)
  DOUBLE PRECISION A(*),BK(K,K),VK(N,K),VTEMP(*)
  ERR = ZERO
  DO I = 1, L
     CALL AV(start_row,N,IAP,JA,A,VK(1:N,I), VTEMP)
     CALL DAXPY(N, -BK(I,I), VK(1,I), 1, VTEMP,1)
     ERR = ERR + DNRM2(N,VTEMP,1) / SQRT(DBLE(N))
  ENDDO
  RETURN
END FUNCTION ERR
