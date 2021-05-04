#!/bin/bash
#
# debian_docker_build is used to build, test, package and add deb's to a
# repository for debian based systems.
#
# release:
# /release/repo   -> repository
# /release/$branch/DEBS/$arch/*.deb
#
# publish:
# /publish/repo   -> repository
# /publish/$branch/DEBS/$arch/*.deb
#

srcdir=$(readlink -e $(dirname ${0})/../..)

# configure based on ARCH
case "${ARCH}" in
"amd64")
  host=x86_64-linux
  gsi_param="--with-gsi=/usr:gcc64"
  bits=64
  ;;
"armhf")
  host=arm-linux-gnueabihf
  gsi_param="--with-gsi=/usr:gcc32"
  bits=32
  ;;
*)
  host=i686-linux
  gsi_param="--with-gsi=/usr:gcc32"
  bits=32
  ;;
esac

if [ "$OS" == "debian_wheezy" -o "${OS:0:7}" = "debian7" ]; then
  export JDK_DIR=/usr/lib/jvm/java-7-openjdk-${ARCH}
fi
config_param="${bits} ${host} bin lib ${gsi_param}"
runtests() {
  testarch ${config_param}
  checktests
}
makelist() {
  dpkg -c $1 |
    grep -v MDSplus/dist |
    grep -v MDSplus/build |
    grep -v MDSplus/doc |
    grep -v egg-info |
    grep -v '/$' |
    awk '{for (i=6; i<NF; i++) printf $i " "; print $NF}' |
    awk '{split($0,a," -> "); print a[1]}' |
    sort
}
debtopkg() {
  if (echo $1 | grep mdsplus${2}_${3} >/dev/null); then
    echo ""
  else
    echo ${1:8+${#2}:-${#3}-${#4}-6}
  fi
}
buildrelease() {
  ### Build release version of MDSplus and then construct installer debs
  set -e
  # ${RELEASEDIR}/${BRANCH}/DEBS will be cleaned in debian_build.sh
  RELEASEDEBS=/release/${BRANCH}/DEBS/${ARCH}
  RELEASEBLD=/workspace/releasebld
  BUILDROOT=${RELEASEBLD}/buildroot
  MDSPLUS_DIR=${BUILDROOT}/usr/local/mdsplus
  rm -Rf ${RELEASEBLD}/${bits}
  mkdir -p ${RELEASEBLD}/${bits} ${BUILDROOT} ${MDSPLUS_DIR}
  pushd ${RELEASEBLD}/${bits}
  config ${config_param} ${ALPHA_DEBUG_INFO}
  if [ -z "$NOMAKE" ]; then
    $MAKE
    $MAKE install
  fi
  popd
  if [ -z "$NOMAKE" ]; then
    mkdir -p ${RELEASEDEBS}
    BRANCH=${BRANCH} \
      RELEASE_VERSION=${RELEASE_VERSION} \
      ARCH=${ARCH} \
      DISTNAME=${DISTNAME} \
      BUILDROOT=${BUILDROOT} \
      PLATFORM=${PLATFORM} \
      ${srcdir}/deploy/platform/debian/debian_build_debs.py
    baddeb=0
    for deb in $(find /release/${BRANCH}/DEBS/${ARCH} -name "*${RELEASE_VERSION}_*\.deb"); do
      pkg=$(debtopkg $(basename $deb) "${BNAME}" ${RELEASE_VERSION} ${ARCH})
      if [ "${#pkg}" = "0" ]; then
        continue
      fi
      if [ "${pkg: -4}" = "_bin" ]; then # ends with _bin
        checkfile=${srcdir}/deploy/packaging/${PLATFORM}/$pkg.$ARCH
      else
        checkfile=${srcdir}/deploy/packaging/${PLATFORM}/$pkg.noarch
      fi
      if [ "$UPDATEPKG" = "yes" ]; then
        mkdir -p ${srcdir}/deploy/packaging/${PLATFORM}
        makelist $deb >${checkfile}
      else
        set +e
        echo "Checking contents of $(basename $deb)"
        if (diff <(makelist $deb) <(sort ${checkfile})); then
          echo "Contents of $(basename $deb) is correct."
        else
          checkstatus baddeb "Failure: Problem with contents of $(basename $deb)" 1
        fi
        set -e
      fi
    done
    checkstatus abort "Failure: Problem with contents of one or more debs. (see above)" $baddeb
    if [ -z "$abort" ] || [ "$abort" = "0" ]; then
      echo "Building repo"
      mkdir -p /release/repo/conf /release/repo/db /release/repo/dists /release/repo/pool
      if [ "${BRANCH}" = "alpha" -o "${BRANCH}" = "stable" ]; then
        component=""
      else
        component=" ${BRANCH}"
      fi
      GPG_HOME=""
      if [ -d /sign_keys/${OS}/.gnupg ]; then
        GPG_HOME="/sign_keys/${OS}"
      elif [ -d /sign_keys/.gnupg ]; then
        GPG_HOME="/sign_keys"
      fi
      if [ ! -z "$GPG_HOME" ]; then
        SIGN_WITH="SignWith: MDSplus"
        rsync -a ${GPG_HOME}/.gnupg /tmp
      fi
      cat - <<EOF >/release/repo/conf/distributions
Origin: MDSplus Development Team
Label: MDSplus
Codename: MDSplus
Architectures: ${ARCHES}
Components: alpha stable${component}
Description: MDSplus packages
${SIGN_WITH}

Origin: MDSplus Development Team
Label: MDSplus-previous
Codename: MDSplus-previous
Architectures: ${ARCHES}
Components: alpha stable${component}
Description: Previous MDSplus release packages
${SIGN_WITH}
EOF
      pushd /release/repo
      reprepro clearvanished
      for deb in $(find /release/${BRANCH}/DEBS/${ARCH} -name "*${RELEASE_VERSION}_*\.deb"); do
        if [ -z "$abort" ] || [ "$abort" = "0" ]; then
          : && HOME=/tmp reprepro -V -C ${BRANCH} includedeb MDSplus $deb
          checkstatus abort "Failure: Problem installing $deb into repository." $?
        else
          break
        fi
      done
      popd
    fi #abort
  fi   #nomake
}

publish() {
  ### DO NOT CLEAN /publish as it may contain valid older release packages
  mkdir -p /publish/${BRANCH}/DEBS
  rsync -a /release/${BRANCH}/DEBS/${ARCH} /publish/${BRANCH}/DEBS/
  LAST_RELEASE_INFO=/publish/${BRANCH}_${OS}
  if [ ! -r /publish/repo ]; then
    : && rsync -a /release/repo /publish/
    checkstatus abort "Failure: Problem copying repo into publish area." $?
  else
    pushd /publish/repo
    rsync -a /release/repo/conf/distributions /publish/repo/conf/
    reprepro clearvanished
    : && env HOME=/sign_keys reprepro -V --keepunused -C ${BRANCH} includedeb MDSplus ../${BRANCH}/DEBS/${ARCH}/*${RELEASE_VERSION}_*.deb ||
      env HOME=/sign_keys reprepro export MDSplus
    checkstatus abort "Failure: Problem installing ${BRANCH} into debian repository." $?
    if [ -f ${LAST_RELEASE_INFO} ]; then
      PREVIOUS_VERSION="$(cat ${LAST_RELEASE_INFO})"
    else
      PREVIOUS_VERSION=
    fi
    echo "PREVIOUS_VERSION=${PREVIOUS_VERSION}"
    if [ -n $PREVIOUS_VERSION ]; then
      : && env HOME=/sign_keys reprepro -V --keepunused -C ${BRANCH} includedeb MDSplus-previous ../${BRANCH}/DEBS/${ARCH}/*${PREVIOUS_VERSION}_*.deb ||
        env HOME=/sign_keys reprepro export MDSplus-previous
      checkstatus abort "Failure: Problem installing previous ${BRANCH} into debian repository." $?
    fi
    popd
  fi
}
