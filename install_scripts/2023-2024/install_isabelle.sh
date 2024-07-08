isabelle="Isabelle2023"
isabelletgz="${isabelle}_linux.tar.gz"
isaurl="https://isabelle.in.tum.de/dist/"

wget "${isaurl}${isabelletgz}"
tar zxf "${isabelletgz}" && rm "${isabelletgz}"
mv "${isabelle}" /usr/local/
ln -s /usr/local/${isabelle}/bin/isabelle /usr/local/bin/

(
printf "[Desktop Entry]\n"
printf "Version=1.0\n"
printf "Name=Isabelle\n"
printf "GenericName=Proof assistant\n"
printf "Exec=/usr/local/%s/bin/isabelle jedit %%F\n" "${isabelle}"
printf "StartupNotify=true\n"
printf "Terminal=false\n"
printf "Icon=/usr/local/%s/lib/icons/isabelle.xpm\n" "${isabelle}"
printf "Type=Application\n"
printf "Categories=Proof;Development;Science;Math\n"
printf "MimeType=text/text;\n"
) > /usr/share/applications/Isabelle.desktop

