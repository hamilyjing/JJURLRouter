
projectName='JJURLRouterHeader'
headerPath=./${projectName}.h
tempHeaderPath=${projectName}.h.temp
searchPath=./

sed '1,$d' $headerPath > ${tempHeaderPath}

echo -e '#import <Foundation/Foundation.h>\n' >> ${tempHeaderPath}

echo -e '#if __has_include(<'${projectName}'/'${projectName}'.h>)\n' >> $tempHeaderPath
echo -e '//! Project version number for '${projectName}'.' >> $tempHeaderPath
echo -e 'FOUNDATION_EXPORT double '${projectName}'VersionNumber;\n' >> $tempHeaderPath
echo -e '//! Project version string for '${projectName}'.' >> $tempHeaderPath
echo -e 'FOUNDATION_EXPORT const unsigned char '${projectName}'VersionString[];\n' >> $tempHeaderPath

echo -e '// In this header, you should import all the public headers of your framework using statements like #import <'${projectName}'/PublicHeader.h>' >> $tempHeaderPath

list=`find ${searchPath} -name "*.h"`
tempName=${projectName}.h

for i in $list
do
if [ $(basename $i) != ${tempName} ] 
then
echo  '#import <'${projectName}'/'$(basename $i)'>' >> $tempHeaderPath
fi
done

echo -e '\n#else\n' >> $tempHeaderPath

for i in $list
do
if [ $(basename $i) != ${tempName} ] 
then
echo  '#import "'$(basename $i)'"' >> $tempHeaderPath
fi
done

echo -e '\n#endif' >> $tempHeaderPath

mv ${tempHeaderPath} ${headerPath}
