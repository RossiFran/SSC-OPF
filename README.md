# Small-signal Constrained Optimal Power Flow (SSC-OPF)
This repository contains codes for developing an optimal power flow with regression-based small-signal stability constraints.

## Data
This repository includes the scripts used for case studies and is organized as follows:
* GD-driven folder: a folder containing the scripts for implementing the SSC-OPF based on the generation dispatch (GD).
* GDCT-driven folder: a folder containing the scripts for implementing the SSC-OPF based on the GD and converters controllers parameters tuning (CT).

In each folder, the scripts are organized following the steps presented in Section III. Methodology of the paper and shown in the figure.
<br>
<br>
![methodology_fc_4_details](https://github.com/francesca16/SSC-OPF/assets/58782534/94f71654-37a0-43f6-8b20-31b38d07ab1b)
<br>
<br>

## Installation

The tool is developed in [Matlab](https://mathworks.com/) and [Python](https://www.python.org/). To run the tool you require the following:
* **Matlab**: Download from the [official site](https://mathworks.com/downloads/)
* **Python $\leq$ Python 3.6.15**: Download from the [official site](https://www.python.org/downloads/)
  
  Install the following libraries, with the indicated version for compatibility reasons:
  * **numpy 1.19.5**:
  * **scikit-learn 0.24.2**:
  * **pyearth**: Clone the [GitHub repository](https://github.com/scikit-learn-contrib/py-earth.git) and install the library using ``sudo`` or ``pip``:
      * Clone the repository:
        ```
        $ git clone git://github.com/scikit-learn-contrib/py-earth.git
          cd py-earth
        ```
      * Install the library:
        ```
        $ sudo python setup.py install
        ```
        or
        ```
        $ pip install -e .
        ```
  
## Usage

To implement each methodology step, follow the instructions in the README file included in the corresponding subfolder.

## References

Rossi, F., Araujo, E. P., Mañe, M. C., & Bellmunt, O. G. (2022, October). Data generation methodology for machine learning-based power system stability studies. In 2022 IEEE PES Innovative Smart Grid Technologies Conference Europe (ISGT-Europe) (pp. 1-5). IEEE.
