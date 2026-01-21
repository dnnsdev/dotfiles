# Clone the repository
git clone https://github.com/alephpt/swaybgplus
cd swaybgplus

python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Install the package
python3 setup.py install

# Or install in development mode
pip install -e .