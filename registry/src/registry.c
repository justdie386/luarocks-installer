#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
//spare yourself, DON'T read this code, i haven't read it either, i just copied it from online, and it works reliably, so i don't really care
#define EXPORT __declspec(dllexport)
/*i'll be very honest 95% of the code i copied online
because i don't know how to use all those windows thing
and im not bothered to learn it*/
int EXPORT registry_key(lua_State *L) {
    HKEY hKey;
    if (RegOpenKeyEx(HKEY_CURRENT_USER, "Environment", 0, KEY_QUERY_VALUE | KEY_SET_VALUE, &hKey) != ERROR_SUCCESS) {
        return 0;
    }

    const char* valueName = lua_tostring(L, 1);
    const char* valueData = lua_tostring(L, 2);

    if (RegSetValueExA(hKey, valueName, 0, REG_SZ, (const BYTE *)valueData, strlen(valueData) + 1) != ERROR_SUCCESS) {
        RegCloseKey(hKey);
        return 0;
    }

    RegCloseKey(hKey);
    return 0;
}


int EXPORT registry_path(lua_State *L) {
    HKEY hKey;
    LONG openResult = RegOpenKeyEx(HKEY_CURRENT_USER, "Environment", 0, KEY_QUERY_VALUE | KEY_SET_VALUE, &hKey);
    if (openResult != ERROR_SUCCESS) {
        printf("Error opening registry key. Error code: %d\n", openResult);
        return 1;
    }

    DWORD dwDataSize = 0;
    LONG sizeResult = RegGetValueA(hKey, NULL, "Path", RRF_RT_REG_SZ, NULL, NULL, &dwDataSize);
    if (sizeResult != ERROR_SUCCESS) {
        printf("Error retrieving Path value size. Error code: %d\n", sizeResult);
        RegCloseKey(hKey);
        return 1;
    }

    LPBYTE lpData = (LPBYTE)malloc(dwDataSize);
    if (lpData == NULL) {
        printf("Error allocating memory.\n");
        RegCloseKey(hKey);
        return 1;
    }

    LONG getResult = RegGetValueA(hKey, NULL, "Path", RRF_RT_REG_SZ, NULL, lpData, &dwDataSize);
    if (getResult != ERROR_SUCCESS) {
        printf("Error retrieving Path value. Error code: %d\n", getResult);
        free(lpData);
        RegCloseKey(hKey);
        return 1;
    }

    LPCSTR lpValueName = lua_tostring(L, 1);
    size_t currentValueSize = strlen(lpData);
    size_t lpValueNameLength = strlen(lpValueName);

    // Allocate memory for the concatenated string
    LPBYTE concatenatedData = (LPBYTE)malloc(currentValueSize + lpValueNameLength + 2);
    if (concatenatedData == NULL) {
        printf("Error allocating memory for concatenated data.\n");
        free(lpData);
        RegCloseKey(hKey);
        return 1;
    }

    // Copy the existing data
    memcpy(concatenatedData, lpData, currentValueSize);

    // Append a semicolon if necessary
    if (currentValueSize > 0 && lpData[currentValueSize - 1] != ';') {
        concatenatedData[currentValueSize] = ';';
        currentValueSize++;
    }

    // Append the Lua string
    memcpy(concatenatedData + currentValueSize, lpValueName, lpValueNameLength + 1); // Include the null terminator

    // Set the new value in the registry
    LONG setResult = RegSetValueExA(hKey, "Path", 0, REG_SZ, concatenatedData, currentValueSize + lpValueNameLength + 1);
    if (setResult != ERROR_SUCCESS) {
        printf("Error setting registry value. Error code: %d\n", setResult);
        free(lpData);
        free(concatenatedData);
        RegCloseKey(hKey);
        return 1;
    }

    // Free allocated memory and close the registry key
    free(lpData);
    free(concatenatedData);
    RegCloseKey(hKey);

    return 0;
}



const luaL_reg funcs[] = {
  { "registry_path", registry_path },
  { "registry_key", registry_key },
  { NULL, NULL }
};

EXPORT int luaopen_registry(lua_State *L){
    luaL_register(L, "registry", funcs);
    return 1; // Added return statement
}
