#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>

double sub_folder_read(DIR *dir, char *dirname)
{
  double cnt = 0.0;
  long bufsize = 256;
  static char *buf = NULL;

  if (!buf) {
    buf = (char*)malloc(bufsize);
  }

  struct dirent *ent;
  while ((ent = readdir (dir)) != NULL) {
    if (ent->d_name[0] == '.') {
      continue;
    }

    char filename[256];
    sprintf(filename, "%s/%s", dirname, ent->d_name);
    FILE *f = fopen(filename, "r");

    while(getline(&buf, &bufsize, f) > 0) {

      double p;
      double  pavg;
      long volume;
      sscanf(buf+20, "%lf,%lf,%ld", &p, &pavg, &volume);

      cnt += p + pavg;
    }

    fclose(f);
  }

  return cnt;
}

int main()
{
  DIR *dir;
  struct dirent *ent;

  double cnt = 0.0;
  if ((dir = opendir ("minute.sh2")) != NULL) {
    /* print all the files and directories within directory */
    while ((ent = readdir (dir)) != NULL) {
      if (ent->d_name[0] == '.') {
        continue;
      }

      char dirname[256];
      sprintf(dirname, "minute.sh2/%s", ent->d_name);
      DIR *subdir = opendir(dirname);
      if (subdir == NULL) {
        continue;
      }

      cnt += sub_folder_read(subdir, dirname);

      closedir(subdir);
    }

    closedir (dir);
  }
  else {
    perror ("");
    return EXIT_FAILURE;
  }

  printf("%lf\n", cnt);
}
