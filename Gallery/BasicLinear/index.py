#!/usr/bin/env python
# Claudio Perez

import os # File and directory handling
import re # Regular expressions (re)


repo_url = 'https://github.com/FEDEASLab/BasicModels/blob/master/'


readme = """
# `FEDEASLab` Basic Examples

## Scripts

{scripts}

## Models

{models}

>Note: This file was generated from a `Makefile` by executing the following terminal command:
>
>`$ make pdf`

"""

model_template = """

(@{model_name}) [`{filename}`]({file_url})

    {description}
"""

script_template_a = """

[`{filename}`]({file_url})

:  {description}
"""


def get_model(script_lines: list):
    """Loop over lines from a file checking for a regex match."""
    regex=r'Model = (Model_\w*)'
    for line in script_lines:
        m = re.search(regex,line)
        if m: return m.group(1)


models = ""
scripts = ""
# Loop over files in current directory.
for file in os.scandir():
    ext = '.m'
    if file.path.endswith(ext):
        # Open file and read lines into a list
        with open(file.path) as f: lines = f.readlines()
        
        # Extract description from 2nd line of file
        description = lines[1].replace("%","").strip()
        filename = file.path.replace('./','')
       
        if 'Model' in filename:
            models = models + model_template.format(
                model_name=filename.replace(ext,''),
                filename=filename,
                file_url=repo_url + filename,
                description=description
            )
        else:
            scripts = "".join((scripts,f"\n\n[`{filename}`]({repo_url + filename})\n\n:  {description}"))
            if (model:=get_model(lines)):
                scripts = "".join((scripts,f"\n\n:  Model: [`{model}`]({repo_url + model + ext}) (@{model})"))





print(readme.format(scripts=scripts,models=models))
