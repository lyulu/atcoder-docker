use ndarray::Array;

fn print_type_of<T>(_: &T) {
    println!("{}", std::any::type_name::<T>())
}

fn main() {
    let arr = Array::from_elem((3, 3), 4);
    println!("{:?}", arr);
    print_type_of(&arr);
}