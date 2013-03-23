#include "ProDefAS.h"
#include "TabString.h"
#include "Toolkit.h"
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
	std::string ns(appElem->Attribute("namespace"));		// c++ style namespace
	// convert it to as style namespace
	char *asns = new char[ns.size() + 1];
	strcpy(asns, ns.c_str());
	Toolkit::StringReplace(asns, "::", ".");
	std::vector<std::string> protocolNameList;
	for (tinyxml2::XMLElement *elem = appElem->FirstChildElement(); elem != NULL; elem = elem->NextSiblingElement())
	{
		std::string genType(elem->Name());
		if ("protocol" == genType)
		{
			ProDefAS proDef(elem);
			proDef.write(outPath, std::string(asns), 0);
			protocolNameList.push_back(proDef.name());
		}
	}
	delete []asns;
	Toolkit::GenerateProtocolTypes(outPath, protocolNameList, 0);
	Toolkit::GenerateProtocolStubs(outPath, protocolNameList, 0);

	return 0;
}
