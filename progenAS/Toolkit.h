#pragma once
/**************************************************************
 * (C) Copyright 2013 Alanmars
 * Keep it simple at first 
 *************************************************************/

#include <vector>
#include <string>

namespace Toolkit
{

/* Replace all occurence of torep in str with rep.
 *
 * str - the dest string
 * torep - the substr to be replaced 
 * rep - the substr to replace
 */
void StringReplace(char *str, const char *torep, const char *rep);

/* Creates the directory path dirPath.
 * The function will create all parent directories necessary to create the directory.
 * Returns true if successful; otherwise returns false.
 * If the path already exists when this function is called, it will return true. */
bool MakePath(const std::string &dirPath);

/* Generate protocol type definitions as file */
void GenerateProtocolTypes(const std::string &dirPath, const std::vector<std::string> &protocolNameList, int tabCount);

/* Generate protocol stub definitions as file */
void GenerateProtocolStubs(const std::string &dirPath, const std::vector<std::string> &protocolNameList, int tabCount);

}