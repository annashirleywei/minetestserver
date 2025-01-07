# Build stage
FROM debian:bookworm-slim AS builder

# Build-time arguments - defaults to dev build of more recent version
ARG LUANTI_VERSION=master
ARG MINETEST_GAME_VERSION=master
# LuaJIT rolling stable branch is v2.1
ARG LUAJIT_VERSION=v2.1

ARG MINETOOLS_VERSION=v0.2.2
ENV MINETOOLS_DL_URL=https://github.com/ronoaldo/minetools/releases/download

# Install all build-dependencies
RUN apt-get update &&\
    apt-get install build-essential cmake gettext libbz2-dev libcurl4-gnutls-dev \
        libfreetype6-dev libglu1-mesa-dev libgmp-dev \
        libjpeg-dev libjsoncpp-dev libleveldb-dev \
        libogg-dev libopenal-dev libpng-dev libpq-dev libspatialindex-dev \
        libsqlite3-dev libvorbis-dev libx11-dev libxxf86vm-dev libzstd-dev \
        postgresql-server-dev-all zlib1g-dev git unzip ninja-build -yq &&\
    apt-get clean

# Fetch source
RUN mkdir -p /usr/src &&\
    git clone --depth=1 -b ${LUANTI_VERSION} \
        https://github.com/minetest/minetest \
        /usr/src/minetest &&\
    rm -rf /usr/src/minetest/.git
RUN git clone --depth=1 https://github.com/asuna-mt/asuna \
        /usr/src/minetest/games/asuna &&\
    git -C /usr/src/minetest/games/asuna checkout asuna
RUN git clone --depth=1 https://github.com/asuna-mt/abdecor \
     /usr/src/minetest/games/asuna/mods/abdecor &&\
git -C /usr/src/minetest/games/asuna/mods/abdecor checkout 2eb43fc
RUN git clone --depth=1 https://github.com/asuna-mt/animalia \
     /usr/src/minetest/games/asuna/mods/animalia &&\
git -C /usr/src/minetest/games/asuna/mods/animalia checkout 68fabf9
RUN git clone --depth=1 https://github.com/asuna-mt/asuna_game_mods \
     /usr/src/minetest/games/asuna/mods/asuna &&\
git -C /usr/src/minetest/games/asuna/mods/asuna checkout 9a10ae8
RUN git clone --depth=1 https://github.com/asuna-mt/awards \
     /usr/src/minetest/games/asuna/mods/awards &&\
git -C /usr/src/minetest/games/asuna/mods/awards checkout beef494
RUN git clone --depth=1 https://github.com/asuna-mt/bakedclay \
     /usr/src/minetest/games/asuna/mods/bakedclay &&\
git -C /usr/src/minetest/games/asuna/mods/bakedclay checkout 860ab55
RUN git clone --depth=1 https://github.com/asuna-mt/beautiflowers \
     /usr/src/minetest/games/asuna/mods/beautiflowers &&\
git -C /usr/src/minetest/games/asuna/mods/beautiflowers checkout b2cd386
RUN git clone --depth=1 https://github.com/asuna-mt/biomes \
     /usr/src/minetest/games/asuna/mods/biomes &&\
git -C /usr/src/minetest/games/asuna/mod/biomes checkout f1a18bf
RUN git clone --depth=1 https://github.com/asuna-mt/bonemeal \
     /usr/src/minetest/games/asuna/mods/bonemeal &&\
git -C /usr/src/minetest/games/asuna/mods/bonemeal checkout a5cd82d
RUN git clone --depth=1 https://github.com/asuna-mt/bottles \
     /usr/src/minetest/games/asuna/mods/bottles &&\
git -C /usr/src/minetest/games/asuna/mods/bottles checkout 020748a
RUN git clone --depth=1 https://github.com/asuna-mt/builtin_item \
     /usr/src/minetest/games/asuna/mods/builtin_item &&\
git -C /usr/src/minetest/games/asuna/mods/builtin_item checkout 49628c4
RUN git clone --depth=1 https://github.com/asuna-mt/caverealms_lite \
     /usr/src/minetest/games/asuna/mods/caverealms_lite &&\
git -C /usr/src/minetest/games/asuna/mods/caverealms_lite checkout 499cfb2
RUN git clone --depth=1 https://github.com/asuna-mt/colorful_beds \
     /usr/src/minetest/games/asuna/mods/colorful_beds &&\
git -C /usr/src/minetest/games/asuna/mods/colorful_beds checkout 40f724c
RUN git clone --depth=1 https://github.com/asuna-mt/creatura \
     /usr/src/minetest/games/asuna/mods/creatura &&\
git -C /usr/src/minetest/games/asuna/mods/creatura checkout 24f9970
RUN git clone --depth=1 https://github.com/asuna-mt/ethereal \
     /usr/src/minetest/games/asuna/mods/ethereal &&\
git -C /usr/src/minetest/games/asuna/mods/ethereal checkout e512e88
RUN git clone --depth=1 https://github.com/asuna-mt/everness \
     /usr/src/minetest/games/asuna/mods/everness &&\
git -C /usr/src/minetest/games/asuna/mods/everness checkout 3724009
RUN git clone --depth=1 https://github.com/asuna-mt/farming \
     /usr/src/minetest/games/asuna/mods/farming &&\
git -C /usr/src/minetest/games/asuna/mods/farming checkout f6c0483
RUN git clone --depth=1 https://github.com/asuna-mt/flowerpot \
     /usr/src/minetest/games/asuna/mods/flowerpot &&\
git -C /usr/src/minetest/games/asuna/mods/flowerpot checkout 1bf935c
RUN git clone --depth=1 https://github.com/asuna-mt/geodes \
     /usr/src/minetest/games/asuna/mods/geodes &&\
git -C /usr/src/minetest/games/asuna/mods/geodes checkout c97407f
RUN git clone --depth=1 https://github.com/asuna-mt/herbs \
     /usr/src/minetest/games/asuna/mods/herbs &&\
git -C /usr/src/minetest/games/asuna/mods/herbs checkout 9100b60
RUN git clone --depth=1 https://github.com/asuna-mt/item_drop \
     /usr/src/minetest/games/asuna/mods/item_drop &&\
git -C /usr/src/minetest/games/asuna/mods/item_drop checkout 887eb7d
RUN git clone --depth=1 https://github.com/asuna-mt/leafstride \
     /usr/src/minetest/games/asuna/mods/leafstride &&\
git -C /usr/src/minetest/games/asuna/mods/leafstride checkout 5db4b4a
RUN git clone --depth=1 https://github.com/asuna-mt/livingjungle \
     /usr/src/minetest/games/asuna/mods/livingjungle &&\
git -C /usr/src/minetest/games/asuna/mods/livingjungle checkout f7c038d
RUN git clone --depth=1 https://github.com/asuna-mt/livingslimes \
     /usr/src/minetest/games/asuna/mods/livingslimes &&\
git -C /usr/src/minetest/games/asuna/mods/livingslimes checkout f3cc3e6
RUN git clone --depth=1 https://github.com/asuna-mt/lootchests_modpack \
     /usr/src/minetest/games/asuna/mods/lootchests_modpack &&\
git -C /usr/src/minetest/games/asuna/mods/lootchests_modpack checkout abfdbf1
RUN git clone --depth=1 https://github.com/asuna-mt/marinara \
     /usr/src/minetest/games/asuna/mods/marinara &&\
git -C /usr/src/minetest/games/asuna/mods/marinara checkout 0550765
RUN git clone --depth=1 https://github.com/asuna-mt/minetest_game \
     /usr/src/minetest/games/asuna/mods/minetest_game &&\
git -C /usr/src/minetest/games/asuna/mods/minetest_game checkout 9585079
RUN git clone --depth=1 https://github.com/asuna-mt/music_modpack \
     /usr/src/minetest/games/asuna/mods/music_modpack &&\
git -C /usr/src/minetest/games/asuna/mods/music_modpack checkout 26a49ab
RUN git clone --depth=1 https://github.com/asuna-mt/naturalbiomes \
     /usr/src/minetest/games/asuna/mods/naturalbiomes &&\
git -C /usr/src/minetest/games/asuna/mods/naturalbiomes checkout 604b6e0
RUN git clone --depth=1 https://github.com/asuna-mt/plantlife_modpack \
     /usr/src/minetest/games/asuna/mods/plantlife_modpack &&\
git -C /usr/src/minetest/games/asuna/mods/plantlife_modpack checkout 13fb07c
RUN git clone --depth=1 https://github.com/asuna-mt/player_monoids \
     /usr/src/minetest/games/asuna/mods/player_monoids &&\
git -C /usr/src/minetest/games/asuna/mods/player_monoids checkout 08bc018
RUN git clone --depth=1 https://github.com/asuna-mt/minetest_sfinv_buttons \
     /usr/src/minetest/games/asuna/mods/minetest_sfinv_buttons &&\
git -C /usr/src/minetest/games/asuna/mods/minetest_sfinv_buttons checkout a35e00b
RUN git clone --depth=1 https://github.com/asuna-mt/minetest_show_wielded_item \
     /usr/src/minetest/games/asuna/mods/minetest_show_wielded_item &&\
git -C /usr/src/minetest/games/asuna/mods/minetest_show_wielded_item checkout e05cbb2
RUN git clone --depth=1 https://github.com/asuna-mt/signs_lib \
     /usr/src/minetest/games/asuna/mods/signs_lib &&\
git -C /usr/src/minetest/games/asuna/mods/signs_lib checkout e5f7343
RUN git clone --depth=1 https://github.com/asuna-mt/skinsdb \
     /usr/src/minetest/games/asuna/mods/skinsdb &&\
git -C /usr/src/minetest/games/asuna/mods/skinsdb checkout 62faec5
RUN git clone --depth=1 https://github.com/asuna-mt/minetest-soup \
     /usr/src/minetest/games/asuna/mods/minetest-soup &&\
git -C /usr/src/minetest/games/asuna/mods/minetest-soup checkout e8696cc
RUN git clone --depth=1 https://github.com/asuna-mt/stamina \
     /usr/src/minetest/games/asuna/mods/stamina &&\
git -C /usr/src/minetest/games/asuna/mods/stamina checkout 13413c3
RUN git clone --depth=1 https://github.com/asuna-mt/telemosaic \
     /usr/src/minetest/games/asuna/mods/telemosaic &&\
git -C /usr/src/minetest/games/asuna/mods/telemosaic checkout 9e1b44a
RUN git clone --depth=1 https://github.com/asuna-mt/too_many_stones \
     /usr/src/minetest/games/asuna/mods/too_many_stones &&\
git -C /usr/src/minetest/games/asuna/mods/too_many_stones checkout e5a86af
RUN git clone --depth=1 https://github.com/asuna-mt/minetest_tt \
     /usr/src/minetest/games/asuna/mods/minetest_tt &&\
git -C /usr/src/minetest/games/asuna/mods/minetest_tt checkout 917bfbb
RUN git clone --depth=1 https://github.com/asuna-mt/minetest_tt_base \
     /usr/src/minetest/games/asuna/mods/minetest_tt_base &&\
git -C /usr/src/minetest/games/asuna/mods/minetest_tt_base checkout 384e6bb
RUN git clone --depth=1 https://github.com/asuna-mt/wielded_light \
     /usr/src/minetest/games/asuna/mods/wielded_light &&\
git -C /usr/src/minetest/games/asuna/mods/wielded_light checkout 3dfc262
RUN git clone --depth=1 https://github.com/asuna-mt/worldgate \
     /usr/src/minetest/games/asuna/mods/worldgate &&\
git -C /usr/src/minetest/games/asuna/mods/worldgate checkout 00d423a
RUN git clone --depth=1 https://github.com/asuna-mt/x_farming \
     /usr/src/minetest/games/asuna/mods/x_farming &&\
git -C /usr/src/minetest/games/asuna/mods/x_farming checkout 02101d6
RUN git clone \
        https://github.com/LuaJIT/LuaJIT \
        /usr/src/luajit &&\
    git -C /usr/src/luajit checkout ${LUAJIT_VERSION}

# Install Contentdb CLI
RUN echo "Building for arch $(uname -m)" &&\
    case $(uname -m) in \
        x86_64)  export ARCH=amd64 ;; \
        aarch64) export ARCH=arm64 ;; \
        *) echo "Unsupported arch $(uname -m)" ; exit 1 ;; \
    esac &&\
    curl -SsL --fail \
        ${MINETOOLS_DL_URL}/${MINETOOLS_VERSION}/contentdb-linux-${ARCH}.zip > /tmp/minetools.zip &&\
        cd /tmp/ && unzip minetools.zip && mv dist/contentdb /usr/bin &&\
        rm /tmp/minetools.zip

# Build LuaJIT
WORKDIR /usr/src/luajit
RUN sed -e 's/PREREL=.*/PREREL=-rolling/g' -i Makefile
RUN make PREFIX=/usr &&\
    make install PREFIX=/usr &&\
    make install PREFIX=/usr DESTDIR=/opt/luajit

# Build server
WORKDIR /tmp/build
RUN cmake -G Ninja /usr/src/minetest \
        -DENABLE_POSTGRESQL=TRUE \
        -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_BUILD_TYPE=RelWithDebug \
        -DBUILD_SERVER=TRUE \
        -DBUILD_CLIENT=FALSE \
        -DBUILD_UNITTESTS=FALSE \
        -DVERSION_EXTRA=unofficial &&\
    ninja -j$(nproc) &&\
    ninja install

# Bundle only the runtime dependencies
FROM debian:bookworm-slim AS runtime
RUN apt-get update &&\
    apt-get install libcurl3-gnutls libgcc-s1 libgmp10 libjsoncpp25 \
        libleveldb1d libncursesw6 libpq5 \
        libspatialindex6 libsqlite3-0 libstdc++6 libtinfo6 zlib1g libzstd1 \
        adduser git -yq &&\
    apt-get clean
# Creates a user to run the server as, with a home dir that can be mounted
# as a volume
RUN adduser --system --uid 30000 --group --home /var/lib/luanti luanti &&\
    chown -R luanti:luanti /var/lib/luanti

# Copy files and folders
COPY --from=builder /usr/share/doc/luanti/minetest.conf.example /etc/luanti/luanti.conf
COPY --from=builder /usr/share/luanti       /usr/share/luanti
COPY --from=builder /usr/src/minetest/games /usr/share/luanti/games
COPY --from=builder /usr/bin/luantiserver   /usr/bin
COPY --from=builder /usr/bin/contentdb      /usr/bin
COPY --from=builder /opt/luajit/usr/        /usr/
ADD luanti-wrapper.sh /usr/bin

# Add symlinks (minetest -> luanti) to easy the upgrade after upstream rename
RUN ln -s /usr/share/luanti /usr/share/minetest &&\
    ln -s /etc/luanti /etc/minetest &&\
    ln -s /etc/luanti/luanti.conf /etc/luanti/minetest.conf &&\
    ln -s /usr/bin/luanti-wrapper.sh /usr/bin/minetest-wrapper.sh

WORKDIR /var/lib/luanti
USER luanti 
EXPOSE 30000/udp 30000/tcp
CMD ["/usr/bin/luanti-wrapper.sh", "--config", "/etc/luanti/luanti.conf", "--gameid", "asuna"]

