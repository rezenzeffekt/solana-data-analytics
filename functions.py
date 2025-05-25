# functions
def write_list(input,output_path):
    """
    saves a list (input) to a txt file (output_path), confirmation output currently commented out, 
    """    
    with open(output_path, 'w') as content:
        content.writelines('\n'.join(input))
    #print(f'list exported to {output_path}')    
def open_list(input,file_path):
    """
    opens a txt file from path (file_path) as a pre-defined list name (input), list output currently commented out, confirmation output currently commented out
    """    
    with open(file_path, 'r') as content:
        for line in content:
            x = line.replace('\n','')
            input.append(x)      
    #print(input)
    #print('list imported from {file_path}')  