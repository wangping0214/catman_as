#include "Toolkit.h"
#include "TabString.h"
#include <algorithm>
#include <iterator>
#include <stdio.h>
#include <assert.h>
#include <stdint.h>
#include <Windows.h>

namespace Toolkit
{

void StringReplace(char *str, const char *torep, const char *rep)
{
	assert(NULL != str);
	assert(NULL != torep);
	assert(NULL != rep);

	size_t torepLen = strlen(torep);
	size_t repLen = strlen(rep);
	size_t resultLen = strlen(str) * repLen / torepLen;
	char *result = (char*)malloc(resultLen + 1);
	memset(result, 0, resultLen);

	char *prev = str;
	char *cur = str;
	while (NULL != cur)
	{
		cur = strstr(cur, torep);
		if (NULL == cur)
			break;
		strncat(result, prev, cur - prev);
		strcat(result, rep);
		prev = cur = cur + torepLen;
	}
	strcat(result, prev);
	strcpy(str, result);
	free(result);
}

void StringReplace(std::string &str, const std::string &torep, const std::string &rep)
{
	for (std::string::size_type i = str.find_first_of(torep); i != std::string::npos; i = str.find_first_of(torep, i + 1))
		str.replace(i, torep.size(), rep);
}

bool MakePath(const std::string &dirPath)
{
	if (dirPath.empty())
		return false;
	std::string tmp(dirPath);
	Toolkit::StringReplace(tmp, "/", "\\");
	if (tmp.find_last_of('\\') != (tmp.size() - 1))
		tmp += '\\';
	for (std::string::size_type i = tmp.find_first_of('\\'); i != std::string::npos; i = tmp.find_first_of('\\', i + 1))
	{
		const std::string &subDir = tmp.substr(0, i);
		uint32_t attrs = GetFileAttributes(subDir.c_str());
		if (attrs == INVALID_FILE_ATTRIBUTES)
		{
			if (!CreateDirectory(subDir.c_str(), NULL))
				return false;
		}
		else if ((attrs & FILE_ATTRIBUTE_DIRECTORY) == 0)
			return false;
	}
	return true;
}

void GenerateProtocolTypes(const std::string &dirPath, const std::string &ns, const std::vector<std::string> &protocolNameList, int tabCount)
{
	std::string filePath(dirPath);
	if (!filePath.empty())
	{
		if (filePath.find_last_of('/') != (filePath.size() - 1))
			filePath += '/';
	}
	filePath += ns;
	Toolkit::StringReplace(filePath, ".", "/");
	if (!Toolkit::MakePath(filePath))
	{
		printf("Failed to make path: %s\n", filePath.c_str());
		return;
	}
	//
	filePath += "/ProtocolTypes.as";
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

void GenerateProtocolStubs(const std::string &dirPath, const std::string &ns, const std::vector<std::string> &protocolNameList, int tabCount)
{
	std::string filePath(dirPath);
	if (!filePath.empty())
	{
		if (filePath.find_last_of('/') != (filePath.size() - 1))
			filePath += '/';
	}
	filePath += ns;
	Toolkit::StringReplace(filePath, ".", "/");
	if (!Toolkit::MakePath(filePath))
	{
		printf("Failed to make path: %s\n", filePath.c_str());
		return;
	}
	filePath += "/ProtocolStubs.as";
	//
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
