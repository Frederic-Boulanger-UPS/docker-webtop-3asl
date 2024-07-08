isabelle="Isabelle2024"
arch=$(uname -m)
if [ "$arch" = "arm64" -o "$arch" = "aarch64" ]
then
  # For computers with ARM chips
  isabelletgz="${isabelle}_linux_arm.tar.gz"
else
  # For computers with Intel chips
  isabelletgz="${isabelle}_linux.tar.gz"
fi

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
