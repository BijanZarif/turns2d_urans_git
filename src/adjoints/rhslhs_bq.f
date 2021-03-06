C        Generated by TAPENADE     (INRIA, Tropics team)
C  Tapenade 3.6 (r4343) - 10 Feb 2012 10:52
C
C  Differentiation of rhslhs in reverse (adjoint) mode:
C   gradient     of useful results: rey q u v vmul sjmat vort
C   with respect to varying inputs: rey q u v vmul sjmat vort
C   RW status of diff variables: rey:incr q:incr u:incr v:incr
C                vmul:incr sjmat:in-out vort:incr
C
C***********************************************************************
      SUBROUTINE RHSLHS_BQ(q, qb, s, sn, vort, vortb, u, ub, v, vb, vmul
     +                     , vmulb, trip, sjmat, sjmatb, xx, xy, yx, yy
     +                     , ug, vg, aj, bj, cj, ak, bk, ck, jd, kd, js
     +                     , je, ks, ke)
      USE PARAMS_GLOBAL
      IMPLICIT NONE
C***********************************************************************
C***********************************************************************
C
      INTEGER jd, kd, js, je, ks, ke
      REAL q(jd, kd, nq), s(jd, kd, nv), sjmat(jd, kd)
      REAL qb(jd, kd, nq), sjmatb(jd, kd)
      REAL xx(jd, kd), xy(jd, kd), yx(jd, kd), yy(jd, kd)
      REAL ug(jd, kd), vg(jd, kd)
      REAL aj(jd, kd), bj(jd, kd), cj(jd, kd)
      REAL ak(jd, kd), bk(jd, kd), ck(jd, kd)
      REAL vmul(jd, kd), vort(jd, kd), sn(jd, kd)
      REAL vmulb(jd, kd), vortb(jd, kd)
      REAL u(jd, kd), v(jd, kd)
      REAL ub(jd, kd), vb(jd, kd)
C local variables
      REAL trip(jd, kd)
C
      INTEGER j, k
      CALL SOURCE_BQ(q, qb, sn, u, v, sjmat, sjmatb, vmul, vmulb, vort, 
     +               vortb, xx, xy, yx, yy, aj, bj, cj, ak, bk, ck, jd, 
     +               kd, js, je, ks, ke)
      CALL DIFFUS_BQ(q, qb, sn, u, v, sjmat, sjmatb, vmul, vmulb, xx, xy
     +               , yx, yy, aj, bj, cj, ak, bk, ck, jd, kd, js, je, 
     +               ks, ke)
      CALL CONVEC_BQ(q, qb, sn, u, ub, v, vb, sjmat, sjmatb, vmul, xx, 
     +               xy, yx, yy, ug, vg, aj, bj, cj, ak, bk, ck, jd, kd
     +               , js, je, ks, ke)
      DO k=1,kd
        DO j=1,jd
          sjmatb(j, k) = 0.0
        ENDDO
      ENDDO
      END
