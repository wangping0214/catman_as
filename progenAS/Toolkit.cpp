#include "Toolkit.h"
#include "TabString.h"
#include <algorithm>
#include <iterator>
#include <stdio.h>

namespace Toolkit
{

bool MakePath(const std::string &dirPath)
{
	return true;
}

void GenerateProtocolTypes(const std::string &dirPath, const std::vector<std::string> &protocolNameList, int tabCount)
{
	std::string filePath(dirPath);
	if (!filePath.empty())
	{
		if (filePath.find_last_of('/') != (filePath.size() - 1))
			filePath += '/';
	}
	filePath += "ProtocolTypes.as";
	FILE *destFile = fopen(filePath.c_str(), "w+");
	fprintf(destFile, "package protocol\n");
	fprintf(destFile, "{\n");
	fprintf(destFile, "%spublic class ProtocolTypes\n", TabString::get(1));
	fprintf(destFile, "%s{\n", TabString::get(1));
	for (std::vector<std::string>::const_iterator it = protocolNameList.begin(), ie = protocolNameList.end(); it != ie; ++ it)
	{
		std::string upperName;
		std::transform(it->begin(), it->end(), std::back_inserter(upperName), toupper);
		fprintf(destFile, "%spublic static const %s : String = \"%s\";\n", TabString::get(2), upperName.c_str(), it->c_str());
	}
	fprintf(destFile, "%s}\n", TabString::get(1));
	fprintf(destFile, "}\n");
	fclose(destFile);
}

void GenerateProtocolStubs(const std::string &dirPath, const std::vector<std::string> &protocolNameList, int tabCount)
{
	std::string filePath(dirPath);
	if (!filePath.empty())
	{
		if (filePath.find_last_of('/') != (filePath.size() - 1))
			filePath += '/';
	}
	filePath += "ProtocolStubs.as";
	FILE *destFile = fopen(filePath.c_str(), "w+");
	fprintf(destFile, "package protocol\n");
	fprintf(destFile, "{\n");
	fprintf(destFile, "%spublic class ProtocolStubs\n", TabString::get(1));
	fprintf(destFile, "%s{\n", TabString::get(1));
	for (std::vector<std::string>::const_iterator it = protocolNameList.begin(), ie = protocolNameList.end(); it != ie; ++ it)
	{
		std::string lowerName;
		std::transform(it->begin(), it->end(), std::back_inserter(lowerName), tolower);
		fprintf(destFile, "%sprivate static var s_%s : %s = new %s();\n", TabString::get(2), lowerName.c_str(), it->c_str(), it->c_str());
	}
	fprintf(destFile, "\n");
	// init protocol stubs
	fprintf(destFile, "%spublic static function load() : void\n", TabString::get(2));
	fprintf(destFile, "%s{\n", TabString::get(2));
	fprintf(destFile, "%s}\n", TabString::get(2));

	fprintf(destFile, "%s}\n", TabString::get(1));
	fprintf(destFile, "}\n");
	fclose(destFile);
}

}
