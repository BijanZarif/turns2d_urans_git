C        Generated by TAPENADE     (INRIA, Tropics team)
C  Tapenade 3.6 (r4343) - 10 Feb 2012 10:52
C
C  Differentiation of turbc_out in reverse (adjoint) mode:
C   gradient     of useful results: q
C   with respect to varying inputs: q
C
C*************************************************************
      SUBROUTINE TURBC_OUT_BQ(q, qb, u, v, ug, vg, xx, xy, yx, yy, jd, 
     +                        kd, js, je, ks, ke, idir)
      USE PARAMS_GLOBAL
      IMPLICIT NONE
C*************************************************************
C*************************************************************
      INTEGER jd, kd
      REAL q(jd, kd, nq)
      REAL qb(jd, kd, nq)
      REAL u(jd, kd), v(jd, kd), ug(jd, kd), vg(jd, kd)
      REAL xx(jd, kd), xy(jd, kd), yx(jd, kd), yy(jd, kd)
      INTEGER js, je, ks, ke, idir
C
C.. local variables
C
      INTEGER j, k, j1, k1, jc, kc, iadd, iadir
      REAL uu
      REAL tmp
      REAL tmp0
      REAL tmp1
      REAL tmp2
      INTEGER branch
      REAL tmpb
      INTRINSIC SIGN
      REAL tmp0b
      INTRINSIC ABS
      REAL tmp2b
      REAL tmp1b
C
      iadd = SIGN(1, idir)
      IF (idir .GE. 0.) THEN
        iadir = idir
      ELSE
        iadir = -idir
      END IF
C
      IF (iadir .EQ. 1) THEN
        IF (idir .EQ. 1) THEN
          j = je
        ELSE IF (idir .EQ. -1) THEN
          j = js
        END IF
        j1 = j + iadd
C
        DO k=ks,ke
          uu = (u(j, k)-ug(j, k)+u(j1, k)-ug(j1, k))*xx(j, k)
          uu = uu + (v(j, k)-vg(j, k)+v(j1, k)-vg(j1, k))*xy(j, k)
          uu = uu*iadd
          IF (uu .LT. 0.) THEN
            CALL PUSHCONTROL1B(1)
          ELSE
            CALL PUSHCONTROL1B(0)
          END IF
        ENDDO
C
C..extrapolate to other halo cells
C
        DO jc=1,je-js
          IF (idir .EQ. 1) THEN
            CALL PUSHINTEGER4(j)
            j = je - jc
            CALL PUSHCONTROL2B(0)
          ELSE IF (idir .EQ. -1) THEN
            CALL PUSHINTEGER4(j)
            j = js + jc
            CALL PUSHCONTROL2B(1)
          ELSE
            CALL PUSHCONTROL2B(2)
          END IF
          CALL PUSHINTEGER4(j1)
          j1 = j + iadd
        ENDDO
        DO jc=je-js,1,-1
          DO k=ke,ks,-1
            tmp2b = qb(j, k, nmv+1)
            qb(j, k, nmv+1) = 0.0
            qb(j1, k, nmv+1) = qb(j1, k, nmv+1) + tmp2b
          ENDDO
          CALL POPINTEGER4(j1)
          CALL POPCONTROL2B(branch)
          IF (branch .EQ. 0) THEN
            CALL POPINTEGER4(j)
          ELSE IF (branch .EQ. 1) THEN
            CALL POPINTEGER4(j)
          END IF
        ENDDO
        DO k=ke,ks,-1
          CALL POPCONTROL1B(branch)
          IF (branch .NE. 0) THEN
            tmp1b = qb(j, k, nmv+1)
            qb(j, k, nmv+1) = 0.0
            qb(j1, k, nmv+1) = qb(j1, k, nmv+1) + tmp1b
          END IF
          qb(j, k, nmv+1) = 0.0
        ENDDO
      ELSE IF (iadir .EQ. 2) THEN
C
C
        IF (idir .EQ. 2) THEN
          k = ke
        ELSE IF (idir .EQ. -2) THEN
          k = ks
        END IF
        k1 = k + iadd
C
        DO j=js,je
          uu = (u(j, k)-ug(j, k)+u(j, k1)-ug(j, k1))*yx(j, k)
          uu = uu + (v(j, k)-vg(j, k)+v(j, k1)-vg(j, k1))*yy(j, k)
          uu = uu*iadd
          IF (uu .LT. 0.) THEN
            CALL PUSHCONTROL1B(1)
          ELSE
            CALL PUSHCONTROL1B(0)
          END IF
        ENDDO
C
C..extrapolate everything to other halo cells
C
        DO kc=1,ke-ks
          IF (idir .EQ. 2) THEN
            CALL PUSHINTEGER4(k)
            k = ke - kc
            CALL PUSHCONTROL2B(0)
          ELSE IF (idir .EQ. -2) THEN
            CALL PUSHINTEGER4(k)
            k = ks + kc
            CALL PUSHCONTROL2B(1)
          ELSE
            CALL PUSHCONTROL2B(2)
          END IF
          CALL PUSHINTEGER4(k1)
          k1 = k + iadd
        ENDDO
        DO kc=ke-ks,1,-1
          DO j=je,js,-1
            tmp0b = qb(j, k, nmv+1)
            qb(j, k, nmv+1) = 0.0
            qb(j, k1, nmv+1) = qb(j, k1, nmv+1) + tmp0b
          ENDDO
          CALL POPINTEGER4(k1)
          CALL POPCONTROL2B(branch)
          IF (branch .EQ. 0) THEN
            CALL POPINTEGER4(k)
          ELSE IF (branch .EQ. 1) THEN
            CALL POPINTEGER4(k)
          END IF
        ENDDO
        DO j=je,js,-1
          CALL POPCONTROL1B(branch)
          IF (branch .NE. 0) THEN
            tmpb = qb(j, k, nmv+1)
            qb(j, k, nmv+1) = 0.0
            qb(j, k1, nmv+1) = qb(j, k1, nmv+1) + tmpb
          END IF
          qb(j, k, nmv+1) = 0.0
        ENDDO
      END IF
      END
