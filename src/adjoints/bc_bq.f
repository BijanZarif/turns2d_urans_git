C        Generated by TAPENADE     (INRIA, Tropics team)
C  Tapenade 3.6 (r4343) - 10 Feb 2012 10:52
C
C  Differentiation of bc in reverse (adjoint) mode:
C   gradient     of useful results: einf vinf uinf q
C   with respect to varying inputs: einf vinf uinf q
C   RW status of diff variables: einf:incr vinf:incr uinf:incr
C                q:in-out
C***********************************************************************
      SUBROUTINE BC_BQ(q, qb, x, y, xx, xy, yx, yy, ug, vg, im, jd, kd, 
     +                 bt)
      USE PARAMS_GLOBAL
      IMPLICIT NONE
C
C  explicitly update the mesh boundaries
C
C***********************************************************************
C***********************************************************************
C
      INTEGER im, jd, kd, j, k, js, je, ks, ke, idir, ib
      REAL q(jd, kd, nq), x(jd, kd), y(jd, kd)
      REAL qb(jd, kd, nq)
      REAL xx(jd, kd), xy(jd, kd), yx(jd, kd), yy(jd, kd), bt(jd, kd)
      REAL ug(jd, kd), vg(jd, kd)
      DO ib=1,nbc_all(im)
        js = jbcs_all(ib, im)
        je = jbce_all(ib, im)
        ks = kbcs_all(ib, im)
        ke = kbce_all(ib, im)
        IF (js .LT. 0) js = jmax + js + 1
        IF (ks .LT. 0) ks = kmax + ks + 1
        IF (je .LT. 0) je = jmax + je + 1
        IF (ke .LT. 0) ke = kmax + ke + 1
C
        IF (js .GT. 1) js = js + nhalo
        IF (ks .GT. 1) ks = ks + nhalo
        IF (je .LT. jmax) je = je + nhalo - 1
        IF (ke .LT. kmax) ke = ke + nhalo - 1
        IF (je .EQ. jmax) je = jd
        IF (ke .EQ. kmax) ke = kd
C
        idir = ibdir_all(ib, im)
C
C.. inviscid wall bc (k = 1 only) 
        IF (ibtyp_all(ib, im) .EQ. 3) THEN
          CALL BCWALL_BQ(q, qb, xx, xy, yx, yy, ug, vg, jd, kd, js, je, 
     +                   ks, ke, idir, .true.)
        ELSE IF (ibtyp_all(ib, im) .EQ. 4) THEN
          CALL BCWALL_BQ(q, qb, xx, xy, yx, yy, ug, vg, jd, kd, js, je, 
     +                   ks, ke, idir, .false.)
        ELSE IF (ibtyp_all(ib, im) .EQ. 5) THEN
          CALL BCWALL_BQ(q, qb, xx, xy, yx, yy, ug, vg, jd, kd, js, je, 
     +                   ks, ke, idir, invisc)
        ELSE IF (ibtyp_all(ib, im) .EQ. 10) THEN
          CALL BCEXTP_BQ(q, qb, jd, kd, js, je, ks, ke, idir)
        ELSE IF (ibtyp_all(ib, im) .EQ. 11) THEN
          CALL BCSYM_BQ(q, qb, jd, kd, js, je, ks, ke, idir)
        ELSE IF (ibtyp_all(ib, im) .EQ. 22) THEN
          CALL BCPERIODIC_BQ(q, qb, jd, kd, js, je, ks, ke, idir)
        ELSE IF (ibtyp_all(ib, im) .EQ. 51) THEN
          CALL BCWAKE_BQ(q, qb, x, y, jd, kd, js, je, ks, ke, idir)
        ELSE IF (ibtyp_all(ib, im) .EQ. 46) THEN
          CALL BCOUT_INF_BQ(q, qb, x, y, xx, xy, yx, yy, ug, vg, jd, kd
     +                      , js, je, ks, ke, idir)
        ELSE IF (ibtyp_all(ib, im) .EQ. 47) THEN
          CALL BCOUT_TRKL_BQ(q, qb, x, y, xx, xy, yx, yy, ug, vg, bt, jd
     +                       , kd, js, je, ks, ke, idir)
        END IF
      ENDDO
      END
