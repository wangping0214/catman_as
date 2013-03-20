#include "ProDefAS.h"
#include "TabString.h"
#include <algorithm>
#include <iterator>

void usage()
{
	printf("Usage: progen -d protocols.xml [-o output_path]");
}

int main(int argc, char *argv[])
{
	if (argc < 2)
	{
		usage();
		return 0;
	}
	std::string proFile(argv[1]);
	std::string outPath;
	if (argc == 3)
		outPath = argv[2];
	tinyxml2::XMLDocument proDoc;
	if (proDoc.LoadFile(proFile.c_str()) != 0)
		printf("Failed to load %s\n", proFile.c_str());
	tinyxml2::XMLElement *appElem = proDoc.RootElement();
	std::string ns(appElem->Attribute("namespace"));
	std::vector<std::string> protocolNameList;
	for (tinyxml2::XMLElement *elem = appElem->FirstChildElement(); elem != NULL; elem = elem->NextSiblingElement())
	{
		std::string genType(elem->Name());
		if ("protocol" == genType)
		{
			ProDefAS proDef(elem);
			proDef.write(outPath, 0);
			protocolNameList.push_back(proDef.name());
		}
	}
	// TODO refactor: write ProtocolType.as
	std::string filePath(outPath);
	if (!filePath.empty())
	{
		if (filePath.find_last_of('/') != (filePath.size() - 1))
			filePath += '/';
	}
	filePath += "ProtocolType.as";
	FILE *destFile = fopen(filePath.c_str(), "w+");
	fprintf(destFile, "package protocol\n");
	fprintf(destFile, "{\n");
	fprintf(destFile, "%spublic class ProtocolType\n", TabString::get(1));
	fprintf(destFile, "%s{\n", TabString::get(1));
	for (std::vector<std::string>::const_iterator it = protocolNameList.begin(), ie = protocolNameList.end(); it != ie; ++ it)
	{
		std::string upperName;
		std::transform(it->begin(), it->end(), std::back_inserter(upperName), toupper);
		fprintf(destFile, "%spublic static const %s : String = \"%s\";\n", TabString::get(2), upperName.c_str(), it->c_str());
	}
	fprintf(destFile, "%s}\n", TabString::get(1));
	fprintf(destFile, "}\n");
	return 0;
}
