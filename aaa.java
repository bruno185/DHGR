public static void quickSort(int[] arr) {
	int subArray = 0;
	Stack<Integer> stack = new Stack<Integer>();
	stack.push(0); // left
	stack.push(arr.length - 1); // right
	do {
		int right = stack.pop();
		int left = stack.pop();
		--subArray;
		do {
			int _left = left;
			int _right = right;
			int pivot = arr[(left + right) / 2];
			do {
				while (pivot < arr[_right]) {
					_right--;
				}
				while (pivot > arr[_left]) {
					_left++;
				}
				if (_left <= _right) {
					if (_left != _right) {
						int temp = arr[_left];
						arr[_left] = arr[_right];
						arr[_right] = temp;
					}
					_right--;
					_left++;
				}
			} while (_right >= _left);
			if (_left < right) {
				++subArray;
				stack.push(_left);
				stack.push(right);
			}
			right = _right;
		} while (left < right);
	} while (subArray > -1);
}